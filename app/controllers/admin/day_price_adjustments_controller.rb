class Admin::DayPriceAdjustmentsController < AdminController
    before_action :set_day_price_adjustment, only: [ :edit, :update ]

    def index
      @admin_day_price_adjustments = DayPriceAdjustment.order(Arel.sql("CASE day_of_week
                                    WHEN 'sunday' THEN 0
                                    WHEN 'monday' THEN 1
                                    WHEN 'tuesday' THEN 2
                                    WHEN 'wednesday' THEN 3
                                    WHEN 'thursday' THEN 4
                                    WHEN 'friday' THEN 5
                                    WHEN 'saturday' THEN 6
                                    ELSE 7
                                  END"))
    end

    def edit
    end

    def update
      if @admin_day_price_adjustment.update(day_price_adjustment_params)
        redirect_to admin_day_price_adjustments_path, notice: "#{@admin_day_price_adjustment.day_of_week.capitalize} surcharge was successfully updated."
      else
        render :edit
      end
    end

    private

    def set_day_price_adjustment
      @admin_day_price_adjustment = DayPriceAdjustment.find(params[:id])
    end

    def day_price_adjustment_params
      params.require(:day_price_adjustment).permit(:id, :day_of_week, :price_adjustment)
    end
end
