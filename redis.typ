#import "@preview/modern-class-presentation:0.1.0": *

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
      #align(top)[#image("Redis.svg", fit: "stretch", width: 70%)]
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
      #align(center + horizon)[#image("caching.jpeg", fit: "stretch", width: 130%)]
    ]
  )
]

#slide(title: "When should I use Redis?", accent: red, footer: "")[
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
      #align(center + horizon)[#image("yomeanme.webp", fit: "cover", width: 100%)]
    ]
  )
]

#slide(title: "Why doesn't everyone use Redis?!?!", accent: red, footer: "")[
  #columns(
    [
    - Introduces New Issues
      - Memory Leaks
      - Cache Busting
      - Thundering Herd / Stampede Herd
      - Scripting Issues
      - Lock Implementation
    - System Complexity
      - Sharding
      - Routing
    ],
    [
      #align(center + horizon)[#image("ironman.jpg", fit: "stretch", width: 105%)]
    ]
  )
]
#section-slide(
  title: "Examples with Redis",
  description: "Some real life applications of Redis in Golang",
  footer: "Introduction To Redis"
)

#slide(title: "Start with a familiar pattern")[
  #columns(
    [
      - Study hours and exam scores often move together.
      - We want a model that describes this relationship clearly.
      - The model should also help estimate an unseen score.
    ],
    [
      #callout(title: "Learning objective", accent: teal)[
        By the end of class, you will interpret the slope and intercept of a
        simple linear model.
      ]
    ],
  )
]

#slide(title: "A model is a useful simplification", eyebrow: "Key idea", accent: coral)[
  #callout(title: "Linear model", accent: coral)[
    $ y = beta_0 + beta_1 x $
  ]

  #v(0.26in)
  The intercept $beta_0$ is the predicted outcome at $x = 0$. The slope
  $beta_1$ describes how the prediction changes as $x$ increases by one unit.
]

#focus-slide(
  [All models are wrong, but some are useful.],
  title: "Core Takeaway",
  accent: primary,
)
