require_relative "test_servers.rb"

#Testes::OBJ.drb_base(nil, 99999).write( [ 'REACT', 1, 1, [ "google.pt" ] ])

class XClient
    def run_detector 
        Process.spawn ":" 
    end
end


RSpec.describe "BaseXtrigger takes from tuple, writes the count to monitorise whith the signal" do
end

RSpec.describe "BaseXtrigger takes from tuple, keeps and write the values to monitorise whith the signal" do
end
RSpec.describe "Describing complete flow" do
    describe "Lets start rolling!" do
        describe "someone fires to BaseXtrigger server tuple" do
            it "trigger for rolling next actions" do
                Testes::OBJ.drb_base(:BaseXtrigger).write([ 'React.please!', "1", "1", "1" ])
            end
        end
    end
end

RSpec.describe "BaseXtrigger takes from tuple, and writes n array's for the XClient take" do


    describe BaseXtrigger, "#run" do
        t = Object 
        it "takes the values from this tuple, and write to xclient by calling run" do
            t_array = ( t = BaseXtrigger.new ).run

            expect( t_array[1].to_i ).to eq(1)
            expect( t_array[2].to_i ).to eq(1)
            expect( t_array[3].to_i ).to eq(1)
        end

        describe BaseXtrigger, "keeps and write the values to monitorize whith the signal" do
            describe Monitorize, "#xxtrigger_pass_values" do
                it "writes the signal to monitorize the keeped value " do
                    Monitorize.xxtrigger_pass_values
                end
                describe BaseXtrigger, "#run" do
                    it "takes the signal and pass the keeped value to monitorization tuple" do
                        expect( t.run[1] ).to eq( ["1...1 / 1"] )
                    end
                end
            end
        end
    end
end
RSpec.describe "XClient take then writes to BaseXdivparams and spawn Detector n times" do
    describe XClient, "#run" do
        it "takes the values from this tuple, and write to BaseXdivparams by calling run" do
            XClient.new.run 
        end

        describe BaseXdivparams, "keeps and write the values to monitorize whith the signal" do
            b=""
            it "take and keeps the values from this tuple by calling run" do
                ( b = BaseXdivparams.new ).run[1] 
            end
            describe Monitorize, "#xxdivparams_pass_values" do
                it "writes the signal to monitorize the keeped value " do
                    Monitorize.xxdivparams_pass_values
                end
                describe BaseXdivparams, "#run" do
                    it "takes the signal and pass the keeped value to monitorization tuple" do
                        expect( b.run[1].first ).to eq( ["1 1 count:1"] )
                    end
                end
            end
        end
    end
    describe Process, "#spawn" do
        before do
            @CMDAPIFILE = proc {|site| 
                "ruby lib/start_detector.rb #{site} true true 'from detector.rb to monit' '{:BaseX302=>33302, :BaseX200=>67890}' 'https'"
            }
        end
        describe Process, "#spawn for status 302" do
            it "spawns 'ruby start_detector.rb [ google.com ] ... with param FLAG302: true" do
                Process.spawn( @CMDAPIFILE.call '[\"google.com\"]' )
            end
            describe Detector, "#scavange" do
                it "write to BaseX302 by calling scavange" do
                    true
                end
            end
        end
        describe Process, "#spawn for status 200" do
            it "spawns 'ruby start_detector.rb [ google.pt ] ... with param FLAG200: true" do
                Process.spawn( @CMDAPIFILE.call '[\"google.pt\"]' )
            end
            describe Detector, "#scavange" do
                it "write to BaseX200 by calling scavange" do
                    true
                end
            end
        end
    end
end
RSpec.describe "... whaiting for writes " do
            it "5 seconds" do
                sleep 5
            end
end
RSpec.describe "BaseX302 takes from tuple, keeps and write the values to monitorise whith the signal" do
        describe BaseX302, "#run" do
            describe Monitorize, "#xx302_pass_values" do
                it "writes the signal to monitorize the keeped value " do
                    Monitorize.xx302_pass_values
                end
            end
            it "takes the signal and pass the keeped value to monitorization tuple" do
                expect( BaseX302.new.run[1] ).to eq( ["google.com"] )
            end
        end
end
RSpec.describe "BaseX200 takes from tuple, keeps and write the values to monitorise whith the signal" do
        describe BaseX200, "#run" do
            describe Monitorize, "#xx200_pass_values" do
                it "writes the signal to monitorize the keeped value " do
                    Monitorize.xx200_pass_values
                end
            end
            it "takes the signal and pass the keeped value to monitorization tuple" do
                expect( BaseX200.new.run[1] ).to eq( "google.pt" )
            end
        end

end

%w[ trigger divparams 200 302 ].each { |s| 

    RSpec.describe "write_#{s}_values testing last value with signal" do

        v = "it passes any values"

        before do

            name = instance_eval "(@V ||= X#{s}_values.new).class.name.to_sym"

            value = Table.take[name] = proc { v }

            write = @V.run

            signal = Table.take[name] = proc { 0 }
        end

        describe instance_eval "X#{s}_values", "#run" do
            it "take the signal and write the last value" do
                expect( @V.run[1] ).to eq( v )
            end
            it "holds the @last value" do
                expect( @V.instance_eval "@last" ).to eq( v )
            end
        end
    end

    RSpec.describe "write_#{s}_counts testing last value with signal" do

        c = 1

        before do

            name = instance_eval "(@C ||= X#{s}_counts.new).class.name.to_sym"

            value = Table.take[name] = proc { c }

            write = @C.run
            
            signal = Table.take[name] = proc { 0 }
        end
        describe instance_eval "X#{s}_counts", "#run" do
            it "take the signal and write the value" do
                expect( a = @C.run[1] ).to eq( c )
            end
            it "holds the @last value" do
                expect( @C.instance_eval "@last" ).to eq( c )
            end
        end
    end
}
