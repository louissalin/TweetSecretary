class TrainingSet
    def initialize(user)
        @tweets = Tweet.where(:owner => user.email)
    end

    def to_v1
        set = @tweets.inject([]) {|acc, e| acc.push(e)}
        { training_set: set }
    end
end
