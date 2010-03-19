require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Board do
  it "occupied?" do
    b = Board.new 19
    b.occupied?(0, 0).should be_false
    b[0][0] = 1
    b.occupied?(0, 0).should be_true
  end

  context "WEIQI" do
    before do
      @b = Board.new 19
    end

    it "neighbor?" do
      @b.neighbor?(0, 0, 0, 1).should be_true
      @b.neighbor?(0, 0, 1, 0).should be_true
      @b.neighbor?(0, 0, 0, 2).should be_false
      @b.neighbor?(0, 0, 2, 0).should be_false
      @b.neighbor?(0, 0, 1, 1).should be_false
    end

    context "get_dead_group" do
      it "should return the dead group" do
        @b[0][0] = 1
        @b[0][1] = 2
        @b[1][0] = 2
        group = @b.get_dead_group(0, 0)
        group.size.should == 1
        group[0].should == [0, 0]
      end

      it "should return nil if not dead" do
        @b[0][0] = 1
        @b[0][1] = 2
        group = @b.get_dead_group(0, 0)
        group.should be_nil
      end

      it "should return dead group with all dead stones" do
        @b[0][0] = 1
        @b[0][1] = 1
        @b[1][0] = 2
        @b[1][1] = 2
        @b[0][2] = 2
        group = @b.get_dead_group(0, 0)
        group.size.should == 2
        group[0].should == [0, 0]
        group[1].should == [0, 1]
      end
    end
  end

  context "DAOQI" do
    before do
      @b = Board.new 19, Game::DAOQI
    end

    it "neighbor?" do
      @b.neighbor?(0, 0, 0, 1).should be_true
      @b.neighbor?(0, 0, 1, 0).should be_true
      @b.neighbor?(0, 0, 0, 18).should be_true
      @b.neighbor?(0, 0, 18, 0).should be_true
      @b.neighbor?(0, 0, 0, 2).should be_false
      @b.neighbor?(0, 0, 2, 0).should be_false
      @b.neighbor?(0, 0, 1, 1).should be_false
    end

    it "normalize" do
      @b.normalize(1).should == 1
      @b.normalize(19).should == 0
      @b.normalize(-1).should == 18
    end

    context "get_dead_group" do
      it "should return the dead group" do
        @b[1][1] = 1
        @b[0][1] = 2
        @b[1][0] = 2
        @b[1][2] = 2
        @b[2][1] = 2
        group = @b.get_dead_group(1, 1)
        group.size.should == 1
        group[0].should == [1, 1]
      end

      it "ignore x border on weiqi board" do
        @b[1][0] = 1
        @b[0][0] = 2
        @b[1][1] = 2
        @b[2][0] = 2
        group = @b.get_dead_group(1, 0)
        group.should be_nil
      end

      it "ignore y border on weiqi board" do
        @b[0][1] = 1
        @b[0][0] = 2
        @b[1][1] = 2
        @b[0][2] = 2
        group = @b.get_dead_group(0, 1)
        group.should be_nil
      end

      it "should return nil if not dead" do
        @b[0][0] = 1
        @b[0][1] = 2
        group = @b.get_dead_group(0, 0)
        group.should be_nil
      end
    end
  end
end
