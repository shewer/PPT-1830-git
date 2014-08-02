require "./gpib.rb"

#aaa test 1

#aaa test 2

class ModelController < ApplicationController
	before_filter :find_model

	





	private
	def find_model
		@model = Model.find(params[:id]) if params[:id]
	end
end


class Aa < Array
	def initialize(aaa)
		@aa=2323
		
	end
	
	
end
def method_missing(meth, *args, &blk)
	
end


def
def aeoeu(aa)
	if condition
		
	else
		
	end
end