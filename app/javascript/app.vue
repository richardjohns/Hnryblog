<template>
  <draggable v-model="lists" :options="{group: 'lists'}" class="board dragArea" @end="listMoved">
    <list v-for="(list, index) in lists" :list="list"></list>

    <div class="list">
      <a v-if="!editing" v-on:click="startEditing">Add a List</a>
      <textarea v-if="editing" ref="message" v-model="message" class="form-control mb-1"></textarea>
      <button v-if="editing" v-on:click="submitMessage" class="btn btn-secondary">Add</button>
      <a v-if="editing" v-on:click="editing=false">Cancel</a>
    </div>
  </draggable>
</template>

<script>
import draggable from "vuedraggable"
import list from "components/list"

export default {
  components: { draggable, list }, // gives access to draggable tag above when we render our template.
  props: ["original_lists"],
  data: function() {
    return {
      lists: this.original_lists,
      editing: false,
      message: "",
    }
  },
  methods: {
    startEditing: function() {
      this.editing = true
      this.$nextTick(() => { this.$refs.message.focus() })
    },
    listMoved: function(event) {
      var data = new FormData
      // console.log('This is data before: ',data)
      console.log('This is listMoved event: ',event)
      // console.log('This is this.lists: ', this.lists)
      data.append("list[position]", event.newIndex + 1)
      // console.log('This is data after: ',data)
      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json",
      })
    },
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 10px;
}
.board {
  overflow-x: auto;
  white-space: nowrap;
}
.list {
  background: #E2E4E6;
  border-radius: 3px;
  display: inline-block;
  margin-right: 20px;
  padding: 10px;
  vertical-align: top;
  width: 270px;
}
</style>
// makes drag area visible so that you know that you can drop card there
