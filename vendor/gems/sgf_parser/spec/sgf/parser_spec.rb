require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe Parser, 'with DefaultEventListener' do
    before :each do
      @listener = DefaultEventListener.new
      @parser   = Parser.new @listener
    end

    {'nil' => nil, '' => '', '  ' => '  '}.each do |name, value|
      it "should throw error on bad input - '#{name}'" do
        begin
          @parser.parse(value)
          fail("Should raise error")
        rescue => e
          e.class.should == ArgumentError
        end
      end
    end
    
    it "should call start_game" do
      mock(@listener).start_game
      @parser.parse("(")
    end
    
    it "should call end_game" do
      mock(@listener).end_game
      @parser.parse("(;)")
    end
    
    it "should call start_node" do
      mock(@listener).start_node
      @parser.parse("(;")
    end
    
    it "should call end_variation" do
      mock(@listener).end_variation
      @parser.parse("(;)")
    end
    
    it "should call property_name= with name" do
      mock(@listener).property_name = 'GN'
      @parser.parse("(;GN[)")
    end
    
    it "should call property_value= with value" do
      mock(@listener).property_value = 'a game'
      @parser.parse("(;GN[a game])")
    end
    
    it "should call property_value= for each value" do
      mock(@listener).property_value = 'DB'
      mock(@listener).property_value = 'KS'
      @parser.parse("(;AB[DB][KS])")
    end
    
    it "should call start_variation" do
      mock(@listener).start_variation
      @parser.parse("(;(")
    end
    
    it "should call end_variation" do
      mock(@listener).end_variation
      @parser.parse("(;(;)")
    end
  end
  
  describe Parser, 'with SGF::Model::EventListener' do
    before :each do
      @listener = SGF::Model::EventListener.new
      @parser   = Parser.new @listener
    end
    
    it "should parse game in file" do
      @parser.parse_file File.expand_path(File.dirname(__FILE__) + '/../fixtures/good.sgf')
      game = @listener.game
      game.name.should == 'White (W) vs. Black (B)'
      game.rule.should == 'Japanese'
      game.board_size.should == 19
      game.handicap.should == 0
      game.komi.should == 5.5
      game.played_on.should == "1999-07-28"
      game.white_player.should == 'White'
      game.black_player.should == 'Black'
      game.program.should == 'Cgoban 1.9.2'
      game.time_rule.should == '30:00(5x1:00)'
    end
    
    it "should raise BinaryFileError on parsing binary file" do
      pending 'check if file is binary is problematic'
      lambda {
        @parser.parse_file File.expand_path(File.dirname(__FILE__) + '/../fixtures/test.png')
      }.should raise_error(SGF::BinaryFileError)
    end
    
    it "should parse game without moves" do
      @parser.parse <<-INPUT
      (;GM[1]FF[3]
      GN[White (W) vs. Black (B)];
      )
      INPUT
      game = @listener.game
      game.name.should == 'White (W) vs. Black (B)'
    end
    
    it "should raise error on invalid input" do
      lambda { @parser.parse("123") }.should raise_error
    end
    
    it "should parse a complete game" do
      @parser.parse <<-INPUT
      (;GM[1]FF[3]
      RU[Japanese]SZ[19]HA[0]KM[5.5]
      PW[White]
      PB[Black]
      GN[White (W) vs. Black (B)]
      DT[1999-07-28]
      RE[W+R]
      SY[Cgoban 1.9.2]TM[30:00(5x1:00)];
      AW[ea][eb][ec][bd][dd][ae][ce][de][cf][ef][cg][dg][eh][ci][di][bj][ej]
      AB[da][db][cc][dc][cd][be][bf][ag][bg][bh][ch][dh]LB[bd:A]PL[2]
      C[guff plays A and adum tenukis to fill a 1-point ko. white to kill.
      ]
      (;W[bc];B[bb]
      (;W[ca];B[cb]
      (;W[ab];B[ba]
      (;W[bi]
      C[RIGHT black can't push (but no such luck in the actual game)
      ])
      )))
      )
      INPUT
      game = @listener.game
      game.name.should == 'White (W) vs. Black (B)'
      game.rule.should == 'Japanese'
      game.board_size.should == 19
      game.handicap.should == 0
      game.komi.should == 5.5
      game.result.should == 'W+R'
      game.played_on.should == "1999-07-28"
      game.white_player.should == 'White'
      game.black_player.should == 'Black'
      game.program.should == 'Cgoban 1.9.2'
      game.time_rule.should == '30:00(5x1:00)'
      
      root_node = game.root_node
      root_node.node_type.should == SGF::Model::Constants::NODE_SETUP
      
      node2 = root_node.child
      node2.node_type.should == SGF::Model::Constants::NODE_SETUP
      node2.trunk?.should be_true
      node2.comment.should == "guff plays A and adum tenukis to fill a 1-point ko. white to kill."
      node2.black_moves.should include([3, 0])
      node2.black_moves.should include([3, 1])
      node2.white_moves.should include([4, 0])
      node2.white_moves.should include([4, 1])
      node2.labels[0].should == SGF::Model::Label.new([1, 3], "A")

      var1_root = node2.children[0]
      var1_root.trunk?.should be_false
      var1_root.variation_root?.should be_true
      var1_root.color.should == SGF::Model::Constants::WHITE
      var1_root.move.should == [1, 2]
      
      var1_node2 = var1_root.child
      var1_node2.trunk?.should be_false
      var1_node2.variation_root?.should_not be_true
      var1_node2.color.should == SGF::Model::Constants::BLACK
      var1_node2.move.should == [1, 1]
    end
  end
  
  describe "class methods" do
    it "parse should take a String and parse it and return the game" do
      game = SGF::Parser.parse <<-INPUT
      (;GM[1]FF[3]
      GN[White (W) vs. Black (B)];
      )
      INPUT
      game.name.should == 'White (W) vs. Black (B)'
    end
    
    it "parse should pass debug parameter to event listener" do
      event_listener = SGF::Model::EventListener.new(false)
      mock(SGF::Model::EventListener).new(true) {event_listener}
      SGF::Parser.parse "(;)", true
    end

    it "parse_file should take a sgf file and parse it and return the game" do
      game = SGF::Parser.parse_file File.expand_path(File.dirname(__FILE__) + '/../fixtures/good.sgf')
      game.name.should == 'White (W) vs. Black (B)'
    end

    it "parse_file should pass debug parameter to event listener" do
      event_listener = SGF::Model::EventListener.new(false)
      mock(SGF::Model::EventListener).new(true) {event_listener}
      game = SGF::Parser.parse_file(File.expand_path(File.dirname(__FILE__) + '/../fixtures/good.sgf'), true)
      game.name.should == 'White (W) vs. Black (B)'
    end
    
    it "should parse game with escaped []" do
      game = SGF::Parser.parse_file(File.expand_path(File.dirname(__FILE__) + '/../fixtures/good1.sgf'))
    end
    
    it "is_binary? should return true for binary file" do
      pending 'check if file is binary is problematic'
      SGF::Parser.is_binary?(File.expand_path(File.dirname(__FILE__) + '/../fixtures/test.png')).should be_true
    end
  end
end