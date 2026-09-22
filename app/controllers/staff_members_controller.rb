class StaffMembersController < ApplicationController
  def index
    @staff_members = StaffMember.by_role_and_name
  end

  def show
    @staff_member = StaffMember.find(params[:id])
    @assigned_repairs = @staff_member.assigned_repairs.by_promised_day
    @received_repairs = @staff_member.received_repairs.by_promised_day
  end
end
