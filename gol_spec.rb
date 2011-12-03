require 'rspec'

class Cell
  attr_accessor :world, :x, :y

  def initialize(world, x=0, y=0)
    @world = world
    @x = x
    @y = y
    world.cells << self
  end

  def die!
    world.cells -= [self]
  end

  def dead?
    !world.cells.include?(self)
  end

  def alive?
    world.cells.include?(self)
  end
  
  def alive!
    # if self.neighbours.count == 3 && self.dead?
      world.cells += [self]
    # end
  end

  def neighbours
    @neighbours = []
    world.cells.each do |cell|
      # Has a cell to the north
      if self.x == cell.x && self.y == cell.y - 1
        @neighbours << cell
      end

      # Has a cell to the south
      if self.x == cell.x && self.y == cell.y + 1
        @neighbours << cell
      end

      # Has a cell to the east
      if self.x == cell.x - 1 && self.y == cell.y
        @neighbours << cell
      end

      # Has a cell to the west
      if self.x == cell.x + 1 && self.y == cell.y
        @neighbours << cell
      end

      # Has a cell to the northeast
      if self.x == cell.x - 1 && self.y == cell.y - 1
        @neighbours << cell
      end
      
      # Has a cell to the northwest
      if self.x == cell.x + 1 && self.y == cell.y - 1
        @neighbours << cell
      end

      # Has a cell to the southeast
      if self.x == cell.x - 1 && self.y == cell.y + 1
        @neighbours << cell
      end

      # Has a cell to the southwest
      if self.x == cell.x + 1 && self.y == cell.y + 1
        @neighbours << cell
      end
    end

    @neighbours
  end

  def spawn_at(x, y)
    Cell.new(world, x, y)
  end
end

class World
  attr_accessor :cells

  def initialize
    @cells = []
  end

  def tick!
    cells.each do |cell|
      
      #For Rule #4
      # case 
      # when cell.neighbours.count < 2
      #   cell.die!
      # when cell.neighbours.count > 3
      #   cell.die!
      # when cell.neighbours.count == 3 && Cells.include?(cell)
      #   raise puts "whatevs"
      #   # cell.revive!
      # else
      #   true
      # end

      #For Rule #4  
      # if cell.alive?
      #   unless (2..3) === cell.neighbours.count
      #     cell.die!
      #   end        
      # else #not alive
      #   if cell.neighbours.count == 3
      #     cell.revive!
      #   end
      # end
      
      # First iteration: Ian & Ray implemented the test literally
      # if cell.neighbours.count < 2
      #   cell.die!
      # elsif cell.neighbours.count > 3
      #   cell.die!
      # end
      # 
      # while cell.neighbours.count == 3 && cell.dead?
      #   return cell.revive!
      # end
      
      #Ternary implementation
      # unless (2..3) === cell.neighbours.count ? true : cell.die!
      # end
      
      #Preferred implmentation for Rule #3
      unless (2..3) === cell.neighbours.count
        cell.die!
      end
    end
  end
end

# raise puts Cell.new(:waynes).inspect
# raise puts World.new.inspect
# raise puts World.cells.inspect

describe 'game of life' do
  let(:world) { World.new }
  context "cell utility methods" do
    subject { Cell.new(world) }
    it "spawn relative to" do
      cell = subject.spawn_at(3,5)
      cell.is_a?(Cell).should be_true
      cell.x.should == 3
      cell.y.should == 5
      cell.world.should == subject.world
    end

    it "detects a neighbour to the north" do
      cell = subject.spawn_at(0, 1)
      subject.neighbours.count.should == 1
    end
    
    it "detects a neighbour to the south" do
      cell = subject.spawn_at(0, -1)
      subject.neighbours.count.should == 1
    end

    it "detects a neighbour to the east" do
      cell = subject.spawn_at(1, 0)
      subject.neighbours.count.should == 1
    end

    it "detects a neighbour to the west" do
      cell = subject.spawn_at(-1, 0)
      subject.neighbours.count.should == 1
    end

    it "detects a neighbour to the northeast" do
      cell = subject.spawn_at(1, 1)
      subject.neighbours.count.should == 1
    end
    
    it "detects neighbour to the northwest" do
      cell = subject.spawn_at(-1, 1)
      subject.neighbours.count.should == 1
    end
    
    it "detects a neighbour to the southeast" do
    	cell = subject.spawn_at(1, -1)
    	subject.neighbours.count.should == 1
    end
    
    it "detects a neighbour to the southwest" do
      cell = subject.spawn_at(-1, -1)
      subject.neighbours.count.should == 1
    end

    it "dies" do
      subject.die!
      subject.world.cells.should_not include(subject)
    end
  end

  it "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
    cell = Cell.new(world)
    new_cell = cell.spawn_at(2,0)
    world.tick!
    cell.should be_dead
  end

  it "Rule #2: Any live cell with two or three live neighbours lives on to the next generation." do
    cell = Cell.new(world)
    new_cell = cell.spawn_at(1,0)
    other_new_cell = cell.spawn_at(-1, 0)
    thrid_new_cell = cell.spawn_at(0, 1)
    world.tick!
    cell.should be_alive
  end
  
  it "Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding." do
    cell = Cell.new(world)
    new_cell = cell.spawn_at(1, 0)
    other_new_cell = cell.spawn_at(-1, 0)
    third_new_cell = cell.spawn_at(0, 1)
    forth_new_cell = cell.spawn_at(1, 1)
    world.tick!
    cell.should be_dead
  end
  
  it "Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do
    cell = Cell.new(world)
    cell.die!
    new_cell = Cell.new(world).spawn_at(-1, 0)
    other_new_cell = cell.spawn_at(0,1)
    third_new_cell = cell.spawn_at(1, 0)
    world.tick!
    cell.should be_alive
  end
end
