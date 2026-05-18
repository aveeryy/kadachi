{ inputs, lib, ... }:
let
  repositoryType =
    with lib.types;
    submodule {
      options = {
        path = lib.mkOption {
          type = str;
          description = "Path to the repository";
        };
        label = lib.mkOption {
          type = str;
          description = "Repository label";
        };
      };
    };

  noNotificationOnSoftFailurePatch = builtins.toFile "no-notification-on-soft-failure.patch" ''
     diff --git a/borgmatic/commands/borgmatic.py b/borgmatic/commands/borgmatic.py
    index 83c77829..4a3adfc5 100644
    --- a/borgmatic/commands/borgmatic.py
    +++ b/borgmatic/commands/borgmatic.py
    @@ -157,23 +157,24 @@ class Monitoring_hooks:
             except (OSError, CalledProcessError) as error:
                 raise ValueError(f'Error pinging monitor: {error}')
     
    -        try:
    -            dispatch.call_hooks(
    -                'ping_monitor',
    -                self.config,
    -                dispatch.Hook_type.MONITORING,
    -                self.config_filename,
    -                monitor.State.FAIL if exception else monitor.State.FINISH,
    -                self.monitoring_log_level,
    -                self.dry_run,
    -            )
    -        except (OSError, CalledProcessError) as error:
    -            # If the wrapped code errored, prefer raising that exception, as it's probably more
    -            # important than a monitor failing to ping.
    -            if exception:
    -                return
    +        if not exception or (exception and not isinstance(exception, command.SoftFailureException)):
    +            try:
    +                dispatch.call_hooks(
    +                    'ping_monitor',
    +                    self.config,
    +                    dispatch.Hook_type.MONITORING,
    +                    self.config_filename,
    +                    monitor.State.FAIL if exception else monitor.State.FINISH,
    +                    self.monitoring_log_level,
    +                    self.dry_run,
    +                )
    +            except (OSError, CalledProcessError) as error:
    +                # If the wrapped code errored, prefer raising that exception, as it's probably more
    +                # important than a monitor failing to ping.
    +                if exception:
    +                    return
     
    -            raise ValueError(f'Error pinging monitor: {error}')
    +                raise ValueError(f'Error pinging monitor: {error}')
     
             dispatch.call_hooks(
                 'destroy_monitor',
    @@ -295,6 +296,9 @@ def run_configuration(config_filename, config, config_paths, arguments):  # noqa
                 if encountered_error:
                     raise encountered_error
     
    +    except command.SoftFailureException:
    +        logger.warning("Skipping configuration due to soft failure")
    +        return
         except (OSError, CalledProcessError, ValueError) as error:
             yield from log_error_records('Error running configuration')
     
    diff --git a/borgmatic/hooks/command.py b/borgmatic/hooks/command.py
    index 3bb22f17..77997990 100644
    --- a/borgmatic/hooks/command.py
    +++ b/borgmatic/hooks/command.py
    @@ -31,6 +31,8 @@ BORG_PLACEHOLDER_NAMES = {
     
     VARIABLE_PATTERN = re.compile(r'(?P<left_escape>\\)?\{(?P<name>[\w]+)(?P<right_escape>\\)?\}')
     
    +class SoftFailureException(Exception):
    +    pass
     
     def resolve_variable(match, context, hook_description):
         '''
    @@ -249,7 +251,7 @@ class Before_after_hooks:
                 )
             except (OSError, subprocess.CalledProcessError) as error:
                 if considered_soft_failure(error):
    -                raise
    +                raise SoftFailureException
     
                 # Trigger the after hook manually, since raising here will prevent it from being run
                 # otherwise.
    @@ -276,7 +278,7 @@ class Before_after_hooks:
                 )
             except (OSError, subprocess.CalledProcessError) as error:
                 if considered_soft_failure(error):
    -                raise
    +                raise SoftFailureException
     
                 raise ValueError(f'Error running after {self.before_after} hook: {error}')
     
    diff --git a/tests/unit/hooks/test_command.py b/tests/unit/hooks/test_command.py
    index e7ebd4a1..2e1dc2c9 100644
    --- a/tests/unit/hooks/test_command.py
    +++ b/tests/unit/hooks/test_command.py
    @@ -421,41 +421,6 @@ def test_before_after_hooks_with_before_error_runs_after_hook_and_raises():
             raise AssertionError()  # This should never get called.
     
     
    -def test_before_after_hooks_with_before_soft_failure_raises():
    -    commands = [
    -        {'before': 'repository', 'run': ['foo', 'bar']},
    -        {'after': 'repository', 'run': ['baz']},
    -    ]
    -    flexmock(module).should_receive('filter_hooks').with_args(
    -        commands,
    -        before='action',
    -        action_names=['create'],
    -    ).and_return(flexmock()).once()
    -    flexmock(module).should_receive('filter_hooks').with_args(
    -        commands,
    -        after='action',
    -        action_names=['create'],
    -        state_names=['finish'],
    -    ).never()
    -    flexmock(module).should_receive('execute_hooks').and_raise(OSError)
    -    flexmock(module).should_receive('considered_soft_failure').and_return(True)
    -
    -    with (
    -        pytest.raises(OSError),
    -        module.Before_after_hooks(
    -            command_hooks=commands,
    -            before_after='action',
    -            umask=1234,
    -            working_directory='/working',
    -            dry_run=False,
    -            action_names=['create'],
    -            context1='stuff',
    -            context2='such',
    -        ),
    -    ):
    -        pass
    -
    -
     def test_before_after_hooks_with_wrapped_code_error_runs_after_hook_and_raises():
         commands = [
             {'before': 'repository', 'run': ['foo', 'bar']},
    @@ -525,41 +490,6 @@ def test_before_after_hooks_with_after_error_raises():
             pass
     
     
    -def test_before_after_hooks_with_after_soft_failure_raises():
    -    commands = [
    -        {'before': 'repository', 'run': ['foo', 'bar']},
    -        {'after': 'repository', 'run': ['baz']},
    -    ]
    -    flexmock(module).should_receive('filter_hooks').with_args(
    -        commands,
    -        before='action',
    -        action_names=['create'],
    -    ).and_return(flexmock()).once()
    -    flexmock(module).should_receive('filter_hooks').with_args(
    -        commands,
    -        after='action',
    -        action_names=['create'],
    -        state_names=['finish'],
    -    ).and_return(flexmock()).once()
    -    flexmock(module).should_receive('execute_hooks').and_return(None).and_raise(OSError)
    -    flexmock(module).should_receive('considered_soft_failure').and_return(True)
    -
    -    with (
    -        pytest.raises(OSError),
    -        module.Before_after_hooks(
    -            command_hooks=commands,
    -            before_after='action',
    -            umask=1234,
    -            working_directory='/working',
    -            dry_run=False,
    -            action_names=['create'],
    -            context1='stuff',
    -            context2='such',
    -        ),
    -    ):
    -        pass
    -
    -
     def test_considered_soft_failure_treats_soft_fail_exit_code_as_soft_fail():
         error = subprocess.CalledProcessError(module.SOFT_FAIL_EXIT_CODE, 'try again')
  '';
in
{
  den.schema.host =
    { host, ... }:
    {
      options.services.backups = with lib.types; {
        identifyingIcon = lib.mkOption {
          type = str;
          default = "";
          example = "cat";
        };
        repositories = lib.mkOption {
          type = functionTo (listOf repositoryType);
          default = name: [ ];
          example = name: [
            {
              path = "ssh://user@example.com/backups/${name}";
              label = "backupserver";
            }
            {
              path = "/mnt/backups/${name}";
              label = "local";
            }
          ];
        };
      };
    };
  kasane.services._.backups =
    { host }:
    {
      nixos =
        { config, ... }:
        {
          nixpkgs.overlays = [
            (final: prev: {
              borgmatic = prev.borgmatic.overrideAttrs (previousAttrs: {
                patches = [ noNotificationOnSoftFailurePatch ];
              });
            })
          ];

          services.borgmatic.enable = true;

          sops = {
            secrets = {
              "backups/ssh_private_key".owner = "root";
              "backups/ntfy_token" = {
                owner = "root";
                sopsFile = "${inputs.secrets}/common.yaml";
              };
            };
            templates."backups_ssh_private_key" = {
              content = ''
                ${config.sops.placeholder."backups/ssh_private_key"}
              '';
              owner = "root";
            };
          };
          systemd.timers.borgmatic.timerConfig.RandomizedDelaySec = "0";
        };
    };
}
