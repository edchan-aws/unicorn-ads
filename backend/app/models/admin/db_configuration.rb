class Admin::DbConfiguration < ApplicationRecord
  CONFIG = {
    PRIMARY: {
      REGION:   :ohio,
      MASTER:   :master,
      REPLICAS: [:ohio_ro, :frankfurt, :frankfurt_ro]
    },
    SECONDARY: {
      REGION:   :frankfurt,
      MASTER:   :frankfurt,
      REPLICAS: [:frankfurt_ro]
    }
  }

  def self.master
    # There is always one master writer endpoint, regardless of the region the user
    # is currently in.
    if CONFIG[:SECONDARY][:REGION].equal?(self.master_region)
      CONFIG[:SECONDARY][:MASTER]
    else
      CONFIG[:PRIMARY][:MASTER]
    end
  end

  def self.read_replica
    # You can refine this and use more sophisticated latency or geolocation based
    # policies to route the user to the nearest "local_region_read_replica"
    region_pick = nil
    if CONFIG[:SECONDARY].equal?(self.master_region)
      region_pick = :SECONDARY
    else
      region_pick = :PRIMARY
    end

    # Find the number of replicas configured
    replica_count = CONFIG[region_pick][:REPLICAS].count

    # Randomly pick a replica from it
    CONFIG[region_pick][:REPLICAS][rand(0..replica_count-1)]
  end

  def self.master_region
    master_region = self.find_by(key: :master_region)
    master_region.value.to_sym if master_region.present?
  end
end
