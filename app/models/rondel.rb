class Rondel
  ALL_ACTIONS = %i[
    maneuver_1
    taxation
    factory
    production_1
    maneuver_2
    investor
    import
    production_2
  ].freeze

  def initialize(current_action:)
    @index = ALL_ACTIONS.find_index current_action
    raise "Action #{current_action} does not exist." unless @index
  end

  def current
    ALL_ACTIONS[@index % ALL_ACTIONS.size]
  end

  def next(count)
    case count
    when 0..6
      old_action = @index
      @index = (old_action + count) % ALL_ACTIONS.size

      {
        ok: {
          cost: [count - 3, 0].max,
          current_action: current,
          passed: ALL_ACTIONS[old_action + 1...@index]
        }
      }
    else
      { err: { reason: "Can only advance up to 6 actions (tried #{count})" } }
    end
  end

  def available
    (1..6).map do |i|
      action = ALL_ACTIONS[(i + @index) % ALL_ACTIONS.size]
      {
        id: action,
        label: action.to_s.split('_').first.capitalize,
        cost: [i - 3, 0].max
      }
    end
  end
end
