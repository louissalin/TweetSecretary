class TrainingSetController < ApplicationController
    respond_to :v1_json

    def index
        training_set = TrainingSet.new(current_user)
        respond_to do |format|
            format.v1_json { render v1_json: training_set }
        end
    end
end
