Chartkick.options = {
  height: "400px",
  colors: ["#58a5f0", "#999"]
}
Chartkick.options[:html] = '<div id="%{id}" style="height: %{height};">Loading...</div>'
Chartkick.options[:content_for] = :charts_js
