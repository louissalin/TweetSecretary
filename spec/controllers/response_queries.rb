module ResponseQueries
    def body 
        body = JSON.parse(response.body)
    end

    # Tweet
    def content
        body['content']
    end

    def error
        body['error']
    end

    def tweet
        content['tweet']
    end

    def actions
        tweet['actions']
    end

    # TrainingSet
    def training_set
        content['training_set']
    end
end
