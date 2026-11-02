class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: [:show, :edit, :update, :destroy]

  def index
    @staff_members = policy_scope(StaffMember).by_role_and_name
                                              .includes(:assigned_repairs, :received_repairs)
  end

  def show
    authorize @staff_member
    @assigned_repairs = policy_scope(Repair).where(assigned_mechanic: @staff_member)
                                            .by_promised_day.includes(bike: :customer)
    @received_repairs = policy_scope(Repair).where(received_by: @staff_member)
                                            .by_promised_day.includes(bike: :customer)
  end

  def new
    @staff_member = StaffMember.new
    authorize @staff_member
  end

  def edit
    authorize @staff_member
  end

  def create
    @staff_member = StaffMember.new(permitted_attributes(StaffMember.new))
    authorize @staff_member

    if @staff_member.save
      redirect_to @staff_member, notice: "#{@staff_member.name} was added to the staff."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize @staff_member

    if @staff_member.update(permitted_attributes(@staff_member))
      redirect_to @staff_member, notice: "#{@staff_member.name} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @staff_member

    if @staff_member.destroy
      redirect_to staff_members_path, status: :see_other,
                  notice: "#{@staff_member.name} was removed from the staff."
    else
      redirect_to @staff_member, status: :see_other,
                  alert: @staff_member.errors.full_messages.to_sentence
    end
  end

  private

  def set_staff_member
    @staff_member = StaffMember.find(params[:id])
  end
end
