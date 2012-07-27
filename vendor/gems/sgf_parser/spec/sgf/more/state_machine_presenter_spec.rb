require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/sgf/more/state_machine_presenter')

describe SGF::More::StateMachinePresenter do
  it "should create nodes for start state and all reachable states" do
    stm = SGF::StateMachine.new(:start)
    stm.transition(:start, /a/, :state_a)

    presenter = SGF::More::StateMachinePresenter.new
    presenter.process(stm)
    
    presenter.nodes.should include("start")
    presenter.nodes.should include("state_a")
  end

  it "should create edges for all transitions" do
    stm = SGF::StateMachine.new(:start)
    stm.desc (desc1 = "start + /a/ => state_a")
    stm.transition(:start, /a/, :state_a)
    stm.desc (desc2 = "start + /b/ => state_b")
    stm.transition(:start, /b/, :state_b)

    presenter = SGF::More::StateMachinePresenter.new
    presenter.process(stm)
    
    presenter.edges.should include(["start", "state_a", desc1])
    presenter.edges.should include(["start", "state_b", desc2])
  end
end
