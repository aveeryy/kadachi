class CPUService extends Service {
  static {
    Service.register(
      this,
      {},
      { "current-usage": ["float", "r"], temperature: ["float", "r"] },
    );
  }

  #previousIdle = 0.0;
  #previousTotal = 0.0;
  #currentUsage = 0.0;
  #temperature = 0.0;

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
    this.#temperature =
      Utils.exec(
        "sh -c 'cat /sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1/temp1_input'",
      ) / 1000;
    const currentValues = Utils.exec(
      "sh -c 'cat /proc/stat | grep cpu | head -n 1 | tr -s \" \"'",
    )
      .split(" ")
      .slice(1, 10)
      .map(Number);
    let idle = currentValues[3];
    let total = currentValues.reduce((a, b) => a + b, 0);
    this.#currentUsage =
      1.0 - (idle - this.#previousIdle) / (total - this.#previousTotal);
    this.#previousIdle = idle;
    this.#previousTotal = total;
    this.changed("current-usage");
    this.changed("temperature");
  }
}

const cpu = new CPUService();
export default cpu;
