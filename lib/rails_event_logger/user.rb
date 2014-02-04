module RailsEventLogger
  class User
    class << self
      def current
        Thread.current[:user]
      end

      def current=(user)
        Thread.current[:user] = user
      end
    end # class << self
  end
end # module RailsEventLogger
