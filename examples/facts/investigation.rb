# Known facts about suppliers
(facts! :supplier, [
  {:'#' => 'S1', :name => 'Smith', :status => 20, :city => 'London'},
  {:'#' => 'S2', :name => 'Jones', :status => 10, :city => 'Paris'},
  {:'#' => 'S3', :name => 'Blake', :status => 30, :city => 'Paris'},
  {:'#' => 'S4', :name => 'Clark', :status => 20, :city => 'London'},
  {:'#' => 'S5', :name => 'Adams', :status => 30, :city => 'Athens'}
])

# Known facts about parts
(facts! :part, [
  {:'#' => 'P1', :name => 'Nut',   :color => 'Red',   :weight => 12.0, :city => 'London'},
  {:'#' => 'P2', :name => 'Bolt',  :color => 'Green', :weight => 17.0, :city => 'Paris'},
  {:'#' => 'P3', :name => 'Screw', :color => 'Blue',  :weight => 17.0, :city => 'Oslo'},
  {:'#' => 'P4', :name => 'Screw', :color => 'Red',   :weight => 14.0, :city => 'London'},
  {:'#' => 'P5', :name => 'Cam',   :color => 'Blue',  :weight => 12.0, :city => 'Paris'},
  {:'#' => 'P6', :name => 'Cog',   :color => 'Red',   :weight => 19.0, :city => 'London'}
])

# Known facts about supplies
(facts! :supplies, [
  {:'supplier#' => 'S1', :'part#' => 'P1', :quantity => 300},
  {:'supplier#' => 'S1', :'part#' => 'P2', :quantity => 200},
  {:'supplier#' => 'S1', :'part#' => 'P3', :quantity => 400},
  {:'supplier#' => 'S1', :'part#' => 'P4', :quantity => 200},
  {:'supplier#' => 'S1', :'part#' => 'P5', :quantity => 100},
  {:'supplier#' => 'S1', :'part#' => 'P6', :quantity => 100},
  {:'supplier#' => 'S2', :'part#' => 'P1', :quantity => 300},
  {:'supplier#' => 'S2', :'part#' => 'P2', :quantity => 400},
  {:'supplier#' => 'S3', :'part#' => 'P2', :quantity => 200},
  {:'supplier#' => 'S4', :'part#' => 'P2', :quantity => 200},
  {:'supplier#' => 'S4', :'part#' => 'P4', :quantity => 300},
  {:'supplier#' => 'S4', :'part#' => 'P5', :quantity => 400}
])