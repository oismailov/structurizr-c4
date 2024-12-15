workspace "Tweety" "Tweety RTB"
!identifiers hierarchical


model {
  consumer = person "External User" {
    tags "externalUser"
  }
  tweety = softwareSystem "Tweety" {
    tags tweety
    rtb = container "RTB API" {
      tags api
    }
    demand = container "Demand API" {
      tags api
      localCache = component "Local Cache" {
        tags localCache
      }
      demandController = component "Demand Controller"
      demandService = component "Demand Service"
      sqsService = component "SQS Service"
      redisService = component "Redis Service"
    }

    redis = container "Redis" {
      tags redis
    }
    sqs = container "SQS" {
      tags sqs
    }
    lambda = container "Lambda" {
      tags lambda
    }
  }

  mediaGuard = softwareSystem "MediaGuard"{
    ivt = container "IVT"
    tags mediaGuard
  }

  #software systems
  consumer -> tweety "Get Ads"
  tweety -> mediaGuard "Detect Invalid Traffic (IVT)"

  #containers
  tweety.rtb -> tweety.demand "Get Demands"
  tweety.demand -> tweety.redis "Get Cached Records"
  tweety.lambda -> mediaGuard.ivt "Get IVT"
  tweety.demand -> tweety.sqs "Pushe Message"
  tweety.sqs -> tweety.lambda "Send Message for Processing"
  tweety.lambda -> tweety.redis "Store Processed Record"

  #components
  tweety.demand.demandController -> tweety.demand.demandService "Get Demands"
  tweety.demand.demandService -> tweety.demand.localCache "Read/Write IVT Records"

  tweety.demand.demandService -> tweety.demand.redisService "Read/Write IVT Records"
  tweety.demand.redisService -> tweety.redis "Read/Write IVT Records"

  tweety.demand.demandService -> tweety.demand.sqsService "Push Records for Processing"
  tweety.demand.sqsService -> tweety.sqs "Push Records for Processing"

}

views {
  properties {
    generatr.site.exporter structurizr
  }
  systemContext tweety  "TweetySystemContext" {
    include *
    autolayout lr
  }

  container tweety "TweetyContainers" {
    include *
    autolayout lr
  }

  component tweety.demand "DemandComponents" {
    include *
    autolayout tb
  }

  styles {
    element "Element" {
      color #000000
      background #6495ED
    }
    element "Software System" {
      background #6495ED
    }
    element "Container" {
      background #6495ED
    }
    element "component" {
      background #6495ED
    }
    element "mediaGuard" {
      shape hexagon
      background #87ab69
      color #000000
    }
    element "redis" {
      shape cylinder
      background #DC143C
      color #FFFFFF
    }
    element "sqs" {
      shape pipe
      background #4682B4
      color #FFFFFF
    }
    element "localCache" {
      shape folder
      background #FDB900
      color #000000
    }
    element "externalUser" {
      shape person
      background #6C3BAA
      color #000000
    }
    element "lambda" {
      shape hexagon
      background #FF9900
      color #000000
      border dashed
    }
    element "api" {
      shape hexagon
      background #6495ED
      color #000000
      border dashed
    }
    element "tweety" {
      shape roundedbox
      background #6DA3F7
      color #000000
      border solid
    }
  }
}
}
