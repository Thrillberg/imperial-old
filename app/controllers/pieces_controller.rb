class PiecesController < ApplicationController
  def move
    piece = Piece.find(params[:id])
    origin = Region.find(params[:origin])
    destination = Region.find(params[:destination])

    piece.update({region: destination}) if origin.neighbors.include? destination
  end
end
