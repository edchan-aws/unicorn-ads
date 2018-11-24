class ApplicationController < ActionController::Base

  protected

    def read_replica_db
      Admin::DbConfiguration.read_replica
    end

    def master_db
      Admin::DbConfiguration.master
    end

end
