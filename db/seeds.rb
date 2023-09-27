Appointment.delete_all

Doctor.delete_all
Doctor.create!([
                 {
                   "name": "Rosalyn Rodgers",
                   "address": "Ap #931-9318 Posuere St.",
                   "image": "doctors/doctor-1.png",
                 },
                 {
                   "name": "Griffin Swanson",
                   "address": "P.O. Box 825, 7564 Luctus St.",
                   "image": "doctors/doctor-2.png",
                   "start_time": DateTime.parse("10:00:00+0530"),
                   "break_start_time": DateTime.parse("12:00:00+0530"),
                   "break_end_time": DateTime.parse("13:00:00+0530"),
                   "end_time": DateTime.parse("16:00:00+0530")
                 },
                 {
                   "name": "Victoria Randall",
                   "address": "Ap #142-3397 Non Rd.",
                   "image": "doctors/doctor-1.png",
                   "start_time": DateTime.parse("11:00:00+0530"),
                   "break_start_time": DateTime.parse("13:00:00+0530"),
                   "break_end_time": DateTime.parse("15:00:00+0530"),
                   "end_time": DateTime.parse("17:00:00+0530")
                 },
                 {
                   "name": "Jayme Snow",
                   "address": "Ap #295-2701 Nullam Ave",
                   "image": "doctors/doctor-2.png",
                   "start_time": DateTime.parse("11:00:00+0530"),
                   "break_start_time": DateTime.parse("13:00:00+0530"),
                   "break_end_time": DateTime.parse("14:00:00+0530"),
                   "end_time": DateTime.parse("16:00:00+0530")
                 },
                 {
                   "name": "Rosalyn Rodgers",
                   "address": "Hr #1218 Ab St.",
                   "city": "Perth",
                   "image": "doctors/doctor-2.png",
                   "available": false
                 },
                 {
                   "name": "Rosalyn Rodgers",
                   "address": "Ap #812B Rf St.",
                   "city": "Melbourne",
                   "image": "doctors/doctor-1.png",
                   "available": false
                 },
               ])



User.delete_all
User.create!({
               name: 'Kashish Dreamspring',
               email: 'kjain@dreamspring.org',
               preferred_currency: 'INR'
             })