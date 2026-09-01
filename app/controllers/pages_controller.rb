class PagesController < ApplicationController
  def home
  end

  def services
    @services = [
      { name: "Basic tune-up", price: 18_000 },
      { name: "Full tune-up", price: 32_000 },
      { name: "Wheel true", price: 9_000 },
      { name: "Brake bleed", price: 12_000 },
      { name: "Brake pad replacement", price: 10_000 },
      { name: "Chain replacement", price: 15_000 },
      { name: "Cassette replacement", price: 14_000 },
      { name: "Flat tyre repair", price: 6_000 },
      { name: "Tyre replacement", price: 11_000 },
      { name: "Gear adjustment", price: 8_000 },
      { name: "Headset service", price: 13_000 },
      { name: "Bottom bracket service", price: 16_000 },
      { name: "Fork seal service", price: 20_000 },
      { name: "Full bike wash", price: 7_000 }
    ]
  end

  def visit
  end

  def about
  end
end