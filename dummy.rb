require 'json'

dummyarr = []

dummy = Hash.new
dummy["title"]="알파고"
dummy["description"]="소개"

dummyarr << dummy

dummy = Hash.new
dummy["title"]="알파고2"
dummy["description"]="소개2"

dummyarr << dummy

puts dummyarr.to_json
