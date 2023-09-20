import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="appointment"
export default class extends Controller {
    static targets = ['bookAppointment', 'slotForm', 'userForm', 'payButton']

    initialize() {
        this.activateSlotForm()
    }

    enableBookAppointment() {
        this.bookAppointmentTarget.disabled = false
    }

    disableAllScreens() {
        let appointmentScreens = [
            this.slotFormTarget,
            this.userFormTarget,
        ]

        appointmentScreens.forEach(function (screen) {
            screen.classList.add('d-none')
            screen.classList.remove('active')
        })
    }

    activateUserForm() {
        this.disableAllScreens()

        this.userFormTarget.classList.remove('d-none')
        this.userFormTarget.classList.add('active')
    }

    activateSlotForm() {
        this.disableAllScreens()

        this.slotFormTarget.classList.remove('d-none')
        this.slotFormTarget.classList.add('active')
    }

    convertCurrency(event) {
        this.payButtonTarget.innerText = "Pay " + event.params.text
    }

    connect() {
    }
}
