content = CSV.read('/Users/rubyonrails3/Downloads/targets.csv')
header = content.shift
targeted_student_ids = professor.targeted_student_ids
content.each do |row|
  attributes = {}
  row.each_with_index do |cell, index|
    field = header[index]
    cell = (match = field.match(/^(.+)_id$/) and match and Kernel.const_get(match[1].classify).where(:name => cell).first.try(:id) or cell)
    attributes.merge!(field.to_sym => cell)
  end
  attributes = attributes.merge(role: :user, public: false)
  student = User.invite(attributes, professor) do |u|
    u.skip_invitation = true
  end
  professor.targets.create(student_id: student.id) unless targeted_student_ids.include?(student.id)
end

