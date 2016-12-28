class Event < ApplicationRecord
  # event descriptions and event label 
  LABEL_COMMENT_ADD = "comment-add"
  DESC_COMMENT_ADD = "回复了"
  # for todo
  DESC_TODO_DEL = "删除了任务"
  LABEL_TODO_DEL = "todo-del"

  DESC_TODO_ADD = "创建了任务"
  LABEL_TODO_ADD = "todo-add"

  DESC_TODO_COMPLETED = "完成了任务"
  LABEL_TODO_COMPLETED = "todo-completed"

  DESC_TODO_REOPEN = "重开了任务"
  LABEL_TODO_REOPEN = "todo-reopen"

  LABEL_TODO_DUE_AT_CHANGED = "todo-due-at_changed"

  LABEL_TODO_ASSIGN = "todo-assign"


  # for document
  DESC_DOCUMENT_ADD = "创建了文档"
  LABLE_DOCUMNET_ADD = "documnet-add"

  DESC_DOCUMENT_EDIT = "编辑了文档"
  LABEL_DOCUMENT_EDIT = "document-edit"

  # for todolist

  # for project

  # ancestor could be a: project, calendar, or week_report
  belongs_to :ancestor, polymorphic: true
  belongs_to :invoke_item, polymorphic: true
  belongs_to :actor, class_name: "User", foreign_key: :actor_id
  
  store :extentions,
      accessors: [
          :old_assignee_id,
          :new_assignee_id,
          :old_due_at,
          :new_due_at,
          :comment_id,
          :comment_content
      ],
      coder: JSON

  # show the event information in a similarway to the view for test
  def report
    if action_type == "common" # without commit
      "at #{created_at.strftime("%m-%d")}, #{actor.name} #{action_desc}: #{invoke_item.content}"
    else
      "at #{created_at.strftime("%m-%d")}, #{actor.name} #{action_desc}: #{invoke_item.content} with the following: #{comment_content}"
    end
  end
end
