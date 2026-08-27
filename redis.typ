#import "lib.typ": *

#show: deck.with(
  title: "Introduction to Redis",
  subtitle: "The ultimate solution for all your caching needs... and more!",
  footer: "Supporting scalibility since 7 seconds ago..."
)

#slide(title: "What is Redis?", accent: red, footer: "")[
  #columns(
    [
    - In - memory database
      - Very fast!

    - Supports many different datatypes!
      - Hashes
      - Lists
      - Sorted Lists
      - Sets
      - Streams
    - Pub Sub
      - One Publisher, Multiple Subscribers
    ],
    [
      #align(top)[#image("images/Redis.svg", fit: "stretch", width: 70%)]
    ]
  )
]


#slide(title: "Why should I use Redis?", accent: red, footer: "")[
  #columns(
    [
    - Scalibility
      - Shared across pods
      - Unlike in-pod data structures
      - OKD!

    - Very fast cache!
      - Good for standing infront of databases!

    - Needing a TTL (Time to Live) for caching
      - Stampeding Herd issue.
    
    - Need to send information to many things
      - Exact use of pub sub
        - Can use another hash for late joins
    
    - Good for Rate Limiting
    ],
    [
      #align(center + horizon)[#image("images/diagram.png", fit: "stretch", width: 130%)]
    ]
  )
]

#slide(title: "When should I use Redis?", accent: red, footer: "")[
  #columns(
    [
    - Storage in Multi-pod architecture
      - OKD
    - Need Time to Live for items
    - Leaderboards
    - Multiple clients all seing Live data
    - Faster response times from databases
      - Indices?
    ],
    [
      #align(center + horizon)[#image("images/yomeanme.png", fit: "cover", width: 120%)]
    ]
  )
]

#slide(title: "Why doesn't everyone use Redis?!?!", accent: red, footer: "")[
  #columns(
    [
    - Introduces New Issues / Bugs to Solve
      - Memory Leaks
      - Cache Busting
      - Thundering Herd / Stampeding Herd
      - Scripting Issues
      - Deadlocks
    - System Complexity
      - Sharding
      - Routing
    - Over-Engineering
      - Yes, this is actually valid.
    ],
    [
      #align(center + horizon)[#image("images/ironman.jpg", fit: "stretch", width: 105%)]
    ]
  )
]


#focus-slide(
  [Any questions before showing examples?],
  title: "Questions?",
  accent: primary,
)

#section-slide(
  title: "Real Redis Examples",
  description: "Examples of Redis Usecases in the real world, using the Golang SDK.",
  footer: "Redis Examples",
  accent: red
)

#section-slide(
  title: "EX 1: Basic Redis Usage",
  description: "Multi-Pod Redis Caching with Locks, used in Store 'em Cloud (storemcloud.cs.house)",
  footer: "Redis Examples",
  accent: red
)

#slide(title: "Purpose")[
  #columns(
    [
    - S3 requires presigned Urls, but a new one is generated every time, which ruins browser caching!
      - Seperate rabbit hole. for a different time.
    
    - We need to save generated presigned urls for a specific video to help browsers cache.

    - We can use a Redis cache with a TTL for this!

    ],
    [
      #place(
      top + center,
      dy: -3cm,  
      image("images/storem.png", fit: "contain", width: 70%)
    )
    ]
  )
]

#slide(title: "Connecting to a Redis Client")[
  #columns(
    [
    - Firstly, on pod startup we connect to our Redis Client.
    
    - Best Practices
      - Always ping after connecting to make sure its a stable connection

      - Your redis creds should be environmental variables!
    ],
    [
    #place(
      top + center,
      dy: -1cm,  
      image("images/screenshots/basic/basic0.png", fit: "contain", width: 100%)
    )
    ]
  )
]

#slide(title: "Getting with Redis")[
  #columns(
    [
    - When we are getting a presigned url, we need to first check if a value exists. If so we can just use the value!

    - IF NOT, we need to "lock" the index so only one pod can mod it. WITH a TTL
    
    - Best Practices
      - Redis keys should follow a thing:thing format.
        - #strong()[presignedurl:video:videoid] in here. 

      - Give your locks a short TTL to avoid deadlocking!
    ],
    [
    #place(
      top + center,
      dy: -1cm,  
      image("images/screenshots/basic/basic1.png", fit: "contain", width: 100%)
    )
    ]
  )
]

#slide(title: "Setting With Redis")[
  #columns(
    [
    - Well in the case it doesn't exist, we need to set it!

    - We generate a new presigned URL, and then set it!

    - Best Practices
      - Stagger your time to lives to avoid a bunch of keys resetting at once.
        - Helps against Thundering Herds.
    ],
    [
    #place(
      top + center,
      dy: -1cm,  
      image("images/screenshots/basic/basic2.png", fit: "contain", width: 110%)
    )
    ]
  )
]

#section-slide(
  title: "EX 2: Redis Pub / Sub",
  description: "Multi-Pod Publication / Subscription for the SERGE Storm Team using Redis",
  footer: "Redis Examples",
  accent: red
)

#slide(title: "Infrastructure")[
  #columns(
    [
    - APIHandler
      - Recieves Live Info from the Storm Probe
      - Handles Database writing / info logging
      - Updates Dashboards
    - DashboardHandler
      - Microservice for the Dashboard
      - Handles viewers seeing Live Data
    - So How does One API pod handle 3+ Dashboard pods?
      - Pub Sub!
    ],
    [
      #align(center)[#image("images/screenshots/pubsub0.png", fit: "stretch", width: 115%)]
    ]
  )
]

#slide(title: "Setting Redis Connection for Pub Sub")[
  #columns(
    [
    - Connecting To Redis Client
      - Seperate connection for Pub Sub
    
    - Confirming Connection before going forward.
    ],
    [
      #align(center + horizon)[#image("images/screenshots/pubsub1.png", fit: "stretch", width: 115%)]
    ]
  )
]

#slide(title: "Subscriber")[
  #grid(
    columns: (1fr, 2.3fr),
    gutter: 1em,
    [
    - Recieves new messages when published
      - DOES NOT have a "latest" message.
      - Use a hashmap to accomplish this
    
    - Updates all connected websocket with latest message
    - Channel: "zephyr-update"
    ],
    [
    #place(
      top + center,
      dy: -0.5cm,  
      image("images/screenshots/pubsub2.png", fit: "contain", width: 100%)
    )
    ],
  )
]

#slide(title: "Publisher")[
  #grid(
    columns: (1fr, 2.4fr),
    gutter: 1em,
    [
    - Publishes new messages into the channel

    - Same Channel: "zephyr-update"
    ],
    [
    #place(
      top + center,
      dy: -0.5cm,  
      image("images/screenshots/pubsub3.png", fit: "contain", width: 100%)
    )
    ],
  )
]

#slide(title: "Publisher Recieves and Broadcasts New Data")[
  #grid(
    columns: (1fr, 3fr),
    gutter: 1em,
    [
      - Recieves data from the probe.

      - Publishes new data through the previously stated Redis channel
    ],
    [
    #place(
      top + center,
      dy: -0.5cm,  
      image("images/screenshots/pubsub4.png", fit: "contain", width: 100%)
    )
    ],
  )
]

#slide(title: "Subscriber Recieves!")[
  #grid(
    columns: (1fr, 3fr),
    gutter: 1em,
    [
      - Websockets transmit the newly published data

      - All viewer dashboards update live!
    ],
    [
    #place(
      top + center,
      dy: -0.5cm,  
      image("images/screenshots/pubsub5.png", fit: "contain", width: 100%)
    )
    ],
  )
]


#section-slide(
  title: "EX 3: Rate Limiting With Redis",
  description: "Token Bucket Strategy using Redis .lua scripts",
  footer: "Redis Examples",
  accent: red
)

#slide(title: "Goal")[
  #grid(
    columns: (1fr, 1.8fr),
    gutter: 1em,
    [
      - Rate Limiting websites is crucial!!!
      - Multiple different strategies
        - Fixed Window
        - Sliding Window
        - Leaky Bucket
        - #strong()[Token Bucket]

      - Persistent across Pods!
    ],
    [
    #place(
      top + center,
      dy: -4cm,  
      image("images/heyitsmegoku.png", fit: "contain", height: 85%, width: 100%)
    )
    ],
  )
]



#focus-slide(
  [Thank you for listening! Any questions?],
  title: "Introduction to redis",
  accent: primary,
)
