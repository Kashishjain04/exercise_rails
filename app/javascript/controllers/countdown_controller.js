import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="countdown"
export default class extends Controller {
    static targets = [
        "dateTime",
        "day1", "day0",
        "hour1", "hour0",
        "minute1", "minute0",
        "second1", "second0"
    ]

    countdown() {
        const dateTime = new Date(this.dateTimeTarget.innerText)

        this.interval = setInterval(() => {
            const secondsUntil = (dateTime - Date.now()) / 1000;
            const days = Math.floor(secondsUntil / (60 * 60 * 24));
            const hours = Math.floor((secondsUntil % (60 * 60 * 24)) / (60 * 60));
            const minutes = Math.floor((secondsUntil % (60 * 60)) / (60));
            const seconds = Math.floor(secondsUntil % (60))

            this.day1Target.innerText = Math.floor(days / 10);
            this.day0Target.innerText = days % 10;

            this.hour1Target.innerText = Math.floor(hours / 10);
            this.hour0Target.innerText = hours % 10;

            this.minute1Target.innerText = Math.floor(minutes / 10);
            this.minute0Target.innerText = minutes % 10;

            this.second1Target.innerText = Math.floor(seconds / 10);
            this.second0Target.innerText = seconds % 10;
        }, 1000)
    }

    connect() {
        this.countdown()
    }

    disconnect() {
        clearInterval(this.interval)
    }
}
