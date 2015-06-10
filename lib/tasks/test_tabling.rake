
namespace :test do
	namespace :tabling do
	  task :commitments_not_nil => ["db:test:set_test_env", :environment] do
		  puts Member.all.length.to_s + ' members in the database'
	  end

	  # should be able to specify times and members and have tabling slots generated for you
	  task :generate_assignments_basic => ["db:test:set_test_env", :environment] do
	  	generate_assignments_basic
	  end
	end
end

namespace :db do
  namespace :test do
	desc "Custom dependency to set test environment"
	task :set_test_env do # Note that we don't load the :environment task dependency
	  Rails.env = "test"
	end
  end
end 

def g_random_commitments
	Member.all.each do |member|
		p member.name
		hours = 168.times.map{ Random.rand(2) } 
		p hours
		member.commitments = hours
		member.save
	end
end

def generate_assignments_basic
	puts 'generate_assignments_basic: basic assignment generation testing'
	begin
		times = 1..20
		members = Member.all.to_a
		assignments = TablingManager.generate_tabling_assignments(times, members)

		if not assignments
			puts "\t failed: assignments is nil"
		else
			puts "\t passed: assignments is not nil"
		end

		
	rescue => error
		p '*** FAILED basic_generate_assignments ***'
		p error
		return false
	end
end