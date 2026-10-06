module Repairs
  class IntakePhotosController < ApplicationController
    before_action :set_repair

    def destroy
      photo = @repair.intake_photos.find(params[:id])
      photo.purge

      redirect_back_or_to @repair, status: :see_other,
                          notice: "The photo was removed from repair ##{@repair.id}."
    end

    private

    def set_repair
      @repair = Repair.find(params[:repair_id])
    end
  end
end
