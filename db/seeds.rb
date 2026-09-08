
if ServiceType.exists?
  puts "Already seeded — skipping."
  return
end

# Services 
service_prices = {
  "Basic tune-up"               => 18_000,
  "Full tune-up"                => 32_000,
  "Wheel true"                  => 9_000,
  "Brake bleed"                 => 12_000,
  "Brake pad replacement"       => 10_000,
  "Chain replacement"           => 15_000,
  "Cassette replacement"        => 14_000,
  "Flat tyre repair"            => 6_000,
  "Tyre replacement"            => 11_000,
  "Gear adjustment"             => 8_000,
  "Headset service"             => 13_000,
  "Bottom bracket service"      => 16_000,
  "Fork seal service"           => 20_000,
  "Full bike wash"              => 7_000,
  "Spoke replacement"           => 5_000,
  "Handlebar tape replacement"  => 6_000,
  "Saddle replacement"          => 9_000,
  "Pedal replacement"           => 7_000,
  "Disc brake rotor replacement" => 13_000,
  "Suspension fork service"     => 25_000,
  "Frame alignment check"       => 10_000,
  "Wheel bearing replacement"   => 12_000
}

service_by_name = service_prices.map { |name, price|
  [name, ServiceType.create!(name: name, current_price: price)]
}.to_h


# Staff 

rodrigo = StaffMember.create!(name: "Rodrigo Fuentes", role: "mechanic")
pablo   = StaffMember.create!(name: "Pablo Vidal",     role: "mechanic")
camila_m = StaffMember.create!(name: "Camila Ríos",    role: "mechanic")
antonia = StaffMember.create!(name: "Antonia Silva",   role: "front_desk")


# Customers 

javiera   = Customer.create!(name: "Javiera Carrasco",     phone: "+56 9 1111 1111")
vicente    = Customer.create!(name: "Vicente Cerda",     phone: "+56 9 2222 2222")
andrea    = Customer.create!(name: "Andrea Muñoz",     phone: "+56 9 3333 3333")
diego     = Customer.create!(name: "Diego Herrera",    phone: "+56 9 4444 4444")
camila_c  = Customer.create!(name: "Camila Rojas",     phone: "+56 9 5555 5555")
felipe    = Customer.create!(name: "Felipe Castro",    phone: "+56 9 6666 6666")
valentina = Customer.create!(name: "Valentina Díaz",   phone: "+56 9 7777 7777")
sebastian = Customer.create!(name: "Sebastián Torres", phone: "+56 9 8888 8888")
francisca = Customer.create!(name: "Francisca Vega",   phone: "+56 9 9999 9999")
ignacio   = Customer.create!(name: "Ignacio Ramírez",  phone: "+56 9 1212 1212")
constanza = Customer.create!(name: "Constanza Bravo",  phone: "+56 9 1313 1313")


# Bikes 

bike1  = Bike.create!(customer_id: javiera.id,   make: "Trek",        model: "Marlin 7",   color: "Blue",   serial_number: "TM-1001")
bike2  = Bike.create!(customer_id: vicente.id,    make: "Trek",        model: "Marlin 7",   color: "Blue",   serial_number: "TM-1002")
bike3  = Bike.create!(customer_id: andrea.id,    make: "Giant",       model: "Escape 3",   color: "Red",    serial_number: "GE-2001")
bike4  = Bike.create!(customer_id: diego.id,     make: "Specialized", model: "Sirrus",     color: "Black",  serial_number: "SS-3001")
bike5  = Bike.create!(customer_id: camila_c.id,  make: "Cannondale",  model: "Quick",      color: "White",  serial_number: "CQ-4001")
bike6  = Bike.create!(customer_id: felipe.id,    make: "Trek",        model: "Domane",     color: "Green",  serial_number: "TD-5001")
bike7  = Bike.create!(customer_id: valentina.id, make: "Giant",       model: "Talon",      color: "Grey",   serial_number: "GT-6001")
bike8  = Bike.create!(customer_id: sebastian.id, make: "Scott",       model: "Aspect",     color: "Orange", serial_number: "SA-7001")
bike9  = Bike.create!(customer_id: francisca.id, make: "Bianchi",     model: "Via Nirone", color: "Red",    serial_number: "BV-8001")
bike10 = Bike.create!(customer_id: ignacio.id,   make: "Merida",      model: "Speeder",    color: "Black",  serial_number: "MS-9001")
bike11 = Bike.create!(customer_id: javiera.id,   make: "Giant",       model: "Escape 2",   color: "Silver", serial_number: "GE-2002")
bike12 = Bike.create!(customer_id: constanza.id, make: "Trek",        model: "FX 2",       color: "Blue",   serial_number: "TF-1101")

# Repairs

def add_repair(bike:, received_by:, status:, dropped_off_at:, promised_on:, service_by_name:,
               assigned_mechanic: nil, completed_at: nil, picked_up_at: nil,
               customer_approved: nil, services: [])
  repair = Repair.create!(
    bike_id: bike.id,
    received_by_id: received_by.id,
    assigned_mechanic_id: assigned_mechanic&.id,
    status: status,
    dropped_off_at: dropped_off_at,
    promised_on: promised_on,
    completed_at: completed_at,
    picked_up_at: picked_up_at,
    customer_approved: customer_approved
  )

  services.each do |(name, price_override, discount_note)|
    service_type = service_by_name.fetch(name)
    RepairLineItem.create!(
      repair_id: repair.id,
      service_type_id: service_type.id,
      price_charged: price_override || service_type.current_price,
      discount_note: discount_note
    )
  end

  repair
end


add_repair(
  bike: bike1, received_by: antonia, assigned_mechanic: rodrigo,
  status: "in_progress",
  dropped_off_at: 3.days.ago, promised_on: Date.current + 2.days,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Basic tune-up", nil, nil], ["Wheel true", 8_000, "Regular customer"]]
)

add_repair(
  bike: bike2, received_by: antonia,
  status: "dropped_off",
  dropped_off_at: 1.day.ago, promised_on: Date.current + 4.days,
  service_by_name: service_by_name,
  services: [["Flat tyre repair", nil, nil]]
)


add_repair(
  bike: bike3, received_by: antonia, assigned_mechanic: pablo,
  status: "awaiting_approval",
  dropped_off_at: 2.days.ago, promised_on: Date.current + 3.days,
  service_by_name: service_by_name,
  services: [["Full tune-up", nil, nil], ["Brake pad replacement", nil, nil]]
)

add_repair(
  bike: bike4, received_by: antonia, assigned_mechanic: camila_m,
  status: "declined",
  dropped_off_at: 5.days.ago, promised_on: 3.days.ago, picked_up_at: 4.days.ago,
  customer_approved: false, service_by_name: service_by_name,
  services: [["Suspension fork service", nil, nil]]
)

add_repair(
  bike: bike5, received_by: antonia, assigned_mechanic: rodrigo,
  status: "ready_for_pickup",
  dropped_off_at: 4.days.ago, promised_on: 1.day.ago, completed_at: Time.current,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Chain replacement", nil, nil]]
)


add_repair(
  bike: bike6, received_by: antonia, assigned_mechanic: pablo,
  status: "picked_up",
  dropped_off_at: Time.current.beginning_of_day + 9.hours,
  promised_on: Date.current,
  completed_at: Time.current.beginning_of_day + 15.hours,
  picked_up_at: Time.current.beginning_of_day + 16.hours,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Flat tyre repair", nil, nil]]
)


add_repair(
  bike: bike7, received_by: antonia, assigned_mechanic: camila_m,
  status: "picked_up",
  dropped_off_at: 10.days.ago, promised_on: 8.days.ago,
  completed_at: 7.days.ago, picked_up_at: 6.days.ago,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Gear adjustment", nil, nil], ["Brake bleed", nil, nil]]
)


add_repair(
  bike: bike8, received_by: antonia, assigned_mechanic: rodrigo,
  status: "in_progress",
  dropped_off_at: 1.day.ago, promised_on: Date.current + 5.days,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Full bike wash", nil, nil], ["Headset service", nil, nil]]
)


add_repair(
  bike: bike9, received_by: antonia, assigned_mechanic: pablo,
  status: "awaiting_approval",
  dropped_off_at: Time.current, promised_on: Date.current + 2.days,
  service_by_name: service_by_name,
  services: [["Bottom bracket service", nil, nil]]
)


add_repair(
  bike: bike10, received_by: antonia, assigned_mechanic: camila_m,
  status: "picked_up",
  dropped_off_at: 20.days.ago, promised_on: 18.days.ago,
  completed_at: 17.days.ago, picked_up_at: 16.days.ago,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Tyre replacement", nil, nil]]
)


add_repair(
  bike: bike11, received_by: antonia,
  status: "dropped_off",
  dropped_off_at: Time.current, promised_on: Date.current + 3.days,
  service_by_name: service_by_name,
  services: [["Handlebar tape replacement", nil, nil]]
)


add_repair(
  bike: bike1, received_by: antonia, assigned_mechanic: rodrigo,
  status: "picked_up",
  dropped_off_at: 60.days.ago, promised_on: 58.days.ago,
  completed_at: 57.days.ago, picked_up_at: 56.days.ago,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Wheel true", nil, nil]]
)


add_repair(
  bike: bike3, received_by: antonia, assigned_mechanic: pablo,
  status: "picked_up",
  dropped_off_at: 400.days.ago, promised_on: 398.days.ago,
  completed_at: 397.days.ago, picked_up_at: 396.days.ago,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Basic tune-up", 15_000, "Price from last year's list"]]
)


add_repair(
  bike: bike6, received_by: antonia, assigned_mechanic: camila_m,
  status: "picked_up",
  dropped_off_at: 200.days.ago, promised_on: 198.days.ago,
  completed_at: 197.days.ago, picked_up_at: 196.days.ago,
  customer_approved: true, service_by_name: service_by_name,
  services: [["Brake bleed", nil, nil], ["Spoke replacement", nil, nil]]
)


add_repair(
  bike: bike9, received_by: antonia, assigned_mechanic: rodrigo,
  status: "in_progress",
  dropped_off_at: Time.current, promised_on: Date.current + 6.days,
  customer_approved: true, service_by_name: service_by_name,
  services: [
    ["Frame alignment check", nil, nil],
    ["Wheel bearing replacement", nil, nil],
    ["Pedal replacement", nil, nil]
  ]
)

puts "Seeded: #{ServiceType.count} services, #{StaffMember.count} staff, " \
     "#{Customer.count} customers, #{Bike.count} bikes, #{Repair.count} repairs, " \
     "#{RepairLineItem.count} line items."