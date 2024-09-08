class GPUService extends Service {
  static {
    Service.register(
      this,
      {},
      { "current-usage": ["float", "r"], temperature: ["float", "r"] },
    );
  }

  #currentUsage = 0;
  #temperature = 0;

  get current_usage() {
    return this.#currentUsage;
  }

  get temperature() {
    return this.#temperature;
  }

  constructor() {
    super();
    this.#update();
    const interval = setInterval(() => {
      this.#update();
    }, 2000);
  }

  #update() {
    this.#currentUsage = Utils.exec(
      "sh -c 'cat /sys/class/drm/card?/device/gpu_busy_percent'",
    );
    this.#temperature =
      Utils.exec(
        "sh -c 'cat /sys/class/drm/card?/device/hwmon/hwmon?/temp1_input'",
      ) / 1000;
    this.changed("current-usage");
    this.changed("temperature");
  }
}

const gpu = new GPUService();
export default gpu;
