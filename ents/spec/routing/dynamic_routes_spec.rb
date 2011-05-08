# -*- coding: utf-8 -*-
require 'spec_helper'

describe "routing to dynamic_flows" do
  before(:all) do
    add_routes_runtime do
      resources :workflows do
        resources :chucais,  :controller => "dynamic_flows"
        resources :qingjias, :controller => "dynamic_flows"
      end
    end
  end

  it "routes /forms/new to forms#new" do
    { :get => "/forms/new"}.should route_to(:controller => "forms", :action => "new")
  end

  it "routes /workflows/:workflow_id/chucais/new to dynamic_flows#new" do
    { :get => "/workflows/1/chucais/new"}.should route_to(
                                                          :controller  => "dynamic_flows",
                                                          :action      => "new",
                                                          :workflow_id => "1")

  end

  it "routes POST /workflows/:workflow_id/baoxiaos to dynamic_flows#create" do
    { :post => "/workflows/2/qingjias"}.should route_to(
                                                        :controller =>  "dynamic_flows",
                                                        :action     =>  "create",
                                                        :workflow_id => "2"
                                                        )
  end

end
