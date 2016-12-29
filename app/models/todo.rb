class Todo < ApplicationRecord
  include Commentable

  belongs_to :project
  has_many :events, as: :invoke_item
  belongs_to :creator,   class_name: "User", foreign_key: :creator_id
  

  after_create_commit do
    event_data = {
      action_desc: Event::DESC_TODO_ADD,
      action_label: Event::LABEL_TODO_ADD
    }
    build_event(creator_id, event_data)
  end

  def soft_deleted_by(actor)
    if update_attributes(soft_destroy: true)
      event_data = {
        action_desc: Event::DESC_TODO_DEL,
        action_label: Event::LABLE_TODO_DEL
      }
      build_event(actor.id, event_data)
    end
  end

  def completed_by(actor)
    return self if completed?
    if update_attributes(completed: true, completor_id: actor.id)
      event_data = {
        action_desc: Event::DESC_TODO_COMPLETED,
        action_label: Event::LABEL_TODO_COMPLETED,
      }
      build_event(actor.id, event_data)
    end
    self
  end

  def reopen_by(actor)
    return self unless completed?
    if update_attributes(completed: false, completor_id:nil)
      event_data = {
        action_desc: Event::DESC_TODO_REOPEN,
        action_label: Event::LABEL_TODO_REOPEN,
      }
      build_event(actor.id, event_data)
      self
    end
  end

  def assigned_to(actor, new_assignee)
    old_assignee_id = assignee_id
    new_assignee_id = new_assignee.id
    if update_attributes(assignee_id: new_assignee_id)
      action_desc = "给#{new_assignee.name}指派了任务"
      event_data = {
        action_desc: action_desc,
        action_label: Event::LABEL_TODO_ASSIGN,
        old_assignee_id: old_assignee_id,
        new_assignee_id: new_assignee_id
      }
    end
    build_event(actor.id, event_data)
    self
  end

  def set_due_at(actor, new_time)
    if due_at.present?
      old_due_str = due_at.strftime("%m月%d日")
    else
      old_due_at_str = "没有截止日期"
    end

    new_due_at_str = new_time.strftime("%m月%d日")

    if update_attributes!(due_at: new_time)

      action_desc = "将任务完成时间从 #{old_due_at_str} 修改为 #{new_due_at_str}"

      event_data = {
        action_desc:  action_desc,
        action_label: Event::LABEL_TODO_DUE_AT_CHANGED,
        old_due_at:   due_at,
        new_due_at:   new_time
      }

      build_event(actor.id, event_data)
      
      self
    end
  end

  private

  def build_event(actor_id, event_data)
    @event_params = {
      actor_id: actor_id,
      ancestor_id: self.project.id,
      ancestor_type: "Project",
      action_desc: "",
      action_label: "",
      invoke_item_type: self.class.name,
      invoke_item_id: self.id
    }
    @event_params.merge!(event_data)
    Event.create(@event_params)
  end
end
