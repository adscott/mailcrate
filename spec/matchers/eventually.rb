class Eventually
  def initialize(delegate)
    @delegate = delegate
  end

  def matches?(target)
    @target = target

    count = 0
    until(@delegate.matches?(target)) do
      return false if count >= 10
      sleep(0.1)
      count += 1
    end

    true
  end

  def failure_message
    @delegate.failure_message
  end

  def failure_message_when_negated
    @delegate.failure_message_when_negated
  end
end

def eventually(delegate)
  Eventually.new(delegate)
end
