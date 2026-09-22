class StaffMembersController < ApplicationController
  def index
    @staff_members = StaffMember.by_role_and_name.includes(:assigned_repairs, :received_repairs)
  end

  def show
    @staff_member = StaffMember.find(params[:id])
    @assigned_repairs = @staff_member.assigned_repairs.by_promised_day.includes(bike: :customer)
    @received_repairs = @staff_member.received_repairs.by_promised_day.includes(bike: :customer)
  end
end
