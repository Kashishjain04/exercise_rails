Doctor.delete_all
Doctor.create!([
                 {
                   name: "Neha Kakkar",
                   image: "doctors/doctor-1.png",
                   address: "Jay Nagar, 4th Block",
                 },
                 {
                   name: "Rhea Mhatre",
                   image: "doctors/doctor-2.png",
                   address: "HSR Layout",
                 }
               ])

User.delete_all
User.create!({
               name: 'Kashish Dreamspring',
               email: 'kjain@dreamspring.org',
               preferred_currency: 'INR'
             })