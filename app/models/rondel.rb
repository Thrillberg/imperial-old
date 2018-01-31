class Rondel
  NO_ACTION = :no_action

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
    if current_action.nil?
      @index = NO_ACTION
    else
      @index = ALL_ACTIONS.find_index current_action.to_sym
    end
    raise "Action #{current_action} does not exist." unless @index
  end

  def current
    ALL_ACTIONS[@index % ALL_ACTIONS.size]
  end

  def next(count)
    raise "No current action" if no_action?

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
    if no_action?
      ALL_ACTIONS.map do |action|
        {
          id: action,
          label: action.to_s.split('_').first.capitalize,
          cost: 0
        }
      end
    else
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

  private

  def no_action?
    @index == NO_ACTION
  end
end
