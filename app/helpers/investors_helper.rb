module InvestorsHelper
  def eligible_regions(action, params = nil)
    result = []

    case action
    when /^maneuver/i
      if action == :maneuver_destination
        return Settings.neighbors[params[:origin_region]]
      end

      @game.current_country.pieces.each do |piece|
        unless session[:moved_pieces_ids].include? piece.id
          result << piece.region.name
        end
      end
    when /^factory/i
      return @game.current_country.regions.reject(&:has_factory).map(&:name)
    when /^import/i
      return @game.current_country.regions.map(&:name)
    end

    result
  end
end
