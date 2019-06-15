import Vue from 'vue'

const app = new Vue({
  el: "form.vue",
  data: {
    charCount: 0,
    maxChars: 400,
    zenActive: false
  },
  methods: {
    updateCharCount(e) {
      const charCount = e.target.value.length
      this.charCount = charCount
    },
    closeZen() {
      this.zenActive = false
    }
  }
})
