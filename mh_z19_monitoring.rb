#!/usr/bin/env ruby
#encoding:UTF-8


arg = ENV.fetch("MONITOR") { "co2" }

if ENV['MACKEREL_AGENT_PLUGIN_META'] == '1'
    require 'json'

    meta = {
        :graphs => {
            'mh_z19.'+arg => {
                :label   => arg,
                :unit    => 'integer',
                :metrics => [
                    {
                        :name  => 'monitoring',
                        :label => arg
                    }
                ]
            }
        }
    }


puts '# mackerel-agent-plugin'
puts meta.to_json
exit 0
end

res = `/usr/bin/python3 -m mh_z19  --all | jq .#{arg}`
res.chomp!

puts [ 'mh_z19.'+arg+'.monitoring', res , Time.now.to_i ].join("\t")
