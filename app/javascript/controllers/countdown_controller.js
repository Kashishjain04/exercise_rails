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

    parseTime() {
        const dateTime = new Date(this.dateTimeTarget.innerText)

        const miliSecondsInSecond = 1000
        const secondsInDay = 60 * 60 * 24
        const secondsInHour = 60 * 60
        const secondsInMinute = 60

        const secondsUntil = (dateTime - Date.now()) / miliSecondsInSecond;
        const days = Math.floor(secondsUntil / secondsInDay);
        const hours = Math.floor((secondsUntil % secondsInDay) / secondsInHour);
        const minutes = Math.floor((secondsUntil % secondsInHour) / secondsInMinute);
        const seconds = Math.floor(secondsUntil % secondsInMinute)

        return {days, hours, minutes, seconds}
    }

    countdown() {
        const [days, hours, minutes, seconds] = this.parseTime()

        this.interval = setInterval(() => {
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
