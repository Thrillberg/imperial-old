class ArmiesController < ApplicationController
  def move
    army = Army.find(params[:id])
    destination = Region.find(params[:destination])
    
    if army.update_attributes({region: destination})
      render json: army
    end
  end
end
