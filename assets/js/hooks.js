let Hooks = {}

Hooks.GoogleRecaptcha = {
    mounted() {
        grecaptcha.render(this.el.id)
    }
}

export default Hooks;