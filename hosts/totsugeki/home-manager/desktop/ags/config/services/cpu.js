class CPUService extends Service {
  static {
    Service.register(this, {}, { "current-usage": ["float", "r"] });
  }

  #previousIdle = 0.0;
  #previousTotal = 0.0;
  #currentUsage = 0.0;

  get current_usage() {
    return this.#currentUsage;
  }

  constructor() {
    super();
    this.#update();
    const interval = setInterval(() => {
      this.#update();
    }, 2000);
  }

  #update() {
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
  }
}

const cpu = new CPUService();
export default cpu;
