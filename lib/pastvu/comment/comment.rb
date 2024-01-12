module Pastvu
  class Comment < Model
    def replies
      populate_replies unless @comments.nil?
      @replies ||= []
    end

    def replies=(value)
      @replies = value
    end

    def last_changed
      @lastChanged
    end

    def last_changed=(value)
      @lastChanged = value
    end

    def to_hash
      instance_variables.each_with_object({}) do |var, object|
        next if var == :@replies

        var = var[1..-1]
        object[var.to_sym] = method(var).call
      end
    end

    private

    def populate_replies
      @replies = @comments.map do |comment|
        Comment.new comment
      end
    end
  end
end