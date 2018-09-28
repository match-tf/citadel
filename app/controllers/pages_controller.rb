class PagesController < ApplicationController
  layout "home", only: [:home]

  def home
    read_news_config
    random_tip
  end

  private

  def read_news_config
    @news = News.all
    @head = News.first
    @rest = News.all_but_first.first(3)
  end

  def random_tip
    tips = ['If you want to forfeit your match, you don\'t have to ask a tournament host for it. On your desired match page find a red button that says "Forfeit" on it. Save time for both you and your opponent!',
             'Your tournament banner not only appers on your tournament page, but also serves as a background in a tournament list.',
             'Match parameter "Has a Distinct Winner" makes matches behave like a best of. So number of sets must be odd, and scores only need to be submitted until a majority is reached - i.e. a team won the best of.',
             'Having a trouble with several teams being ranked equally? Try adding tiebreakers to your tournament. A good practice is to plan tiebreaker factors in advance so your players will be aware of why they didn\'t make it into playoffs.',
             'Round Robin or Swiss tournament systems don\'t fit your needs? You are free to manually match every team in your own style - use triple elimination, group stages, AFL final eight, or octuple elimination with seeds based on the moon calendar you had your latest nightmare about.',
             'This site originally had an eye-burning white theme and people had to apply to get the ability to host their tournaments.',
             'We have a built-in pick/ban system. Set those to any order and amount you want when generating new matches. You can also mix them up with sets and have, for example: Home Team bans a map, Away team bans a map. Away picks, Home picks and decider is always koth_trainsawlazer_pro_rc1.',
             'Team and roster is not the same thing. Team is a simple collection of players united under a team title. Teams can fit in an unlimited amount of players. Roster is a selection of players from one team that are signing up for a tournament. When team captain signs up for a competition, he draws players from the team (Player Pool) and places them into a roster. Rosters are limited to whatever tournament settings say. Why is it so complicated you may ask? It\'s actually simple and flexible at the same time. Have a large company of players who play sixies, prolander and highlander? Form a big team and participate in various tournaments under the same team title.'
            ]
    @tip = tips.sample
  end

end
