#  To generate mailman_email_addresses.txt, use:
#
#    list_members rochester_jam > mailman_addresses.txt


# subject = "UR jam dates for Spring Semester"
subject = "[Rochester-Jam]  Buffalo Contact Improv Jam"


open('cir/mailman_addresses.txt') do |file|
  file.each do |line|
    email = line.strip
    print "[#{email}]\n"
#    UserMailer.deliver_ci_rochester(subject, email)
  end
end
