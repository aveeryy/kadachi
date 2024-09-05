class RAMService extends Service {
  static {
    Service.register(
      this,
      {},
      {
        "current-usage": ["float", "r"],
        "current-usage-percentage": ["float", "r"],
        "total-available": ["float", "r"],
      },
    );
  }
  #currentUsage = 0;
  #totalAvailable = 0;

  get current_usage() {
    return this.#currentUsage;
  }

  get current_usage_percentage() {
    return this.#currentUsage / this.#totalAvailable;
  }

  get total_available() {
    return this.#totalAvailable;
  }

  constructor() {
    super();
    this.#totalAvailable = Number(
      Utils.exec(
        'sh -c \'cat /proc/meminfo | grep MemTotal | tr -s " " | cut -d " " -f 2\'',
      ),
    );
    this.#update();
    const interval = setInterval(() => {
      this.#update();
    }, 2000);
  }

  #update() {
    this.#currentUsage =
      this.#totalAvailable -
      Number(
        Utils.exec(
          'sh -c \'cat /proc/meminfo | grep MemAvailable | tr -s " " | cut -d " " -f 2\'',
        ),
      );
    this.emit("changed");
    this.notify("current-usage");
    this.notify("current-usage-percentage");
  }
}

const ram = new RAMService();
export default ram;
