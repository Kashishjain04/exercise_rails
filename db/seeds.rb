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
                   "start_time": Time.parse("10:00:00"),
                   "break_start_time": Time.parse("12:00:00"),
                   "break_end_time": Time.parse("13:00:00"),
                   "end_time": Time.parse("16:00:00")
                 },
                 {
                   "name": "Victoria Randall",
                   "address": "Ap #142-3397 Non Rd.",
                   "image": "doctors/doctor-1.png",
                   "start_time": Time.parse("11:00:00"),
                   "break_start_time": Time.parse("13:00:00"),
                   "break_end_time": Time.parse("15:00:00"),
                   "end_time": Time.parse("17:00:00")
                 },
                 {
                   "name": "Jayme Snow",
                   "address": "Ap #295-2701 Nullam Ave",
                   "image": "doctors/doctor-2.png",
                   "start_time": Time.parse("11:00:00"),
                   "break_start_time": Time.parse("13:00:00"),
                   "break_end_time": Time.parse("14:00:00"),
                   "end_time": Time.parse("16:00:00")
                 },
               ])



User.delete_all
User.create!({
               name: 'Kashish Dreamspring',
               email: 'kjain@dreamspring.org',
               preferred_currency: 'INR'
             })