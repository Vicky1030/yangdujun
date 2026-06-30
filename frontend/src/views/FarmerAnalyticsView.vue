<template>
  <div class="page" v-loading="loading">
    <section class="panel analytics-head">
      <div>
        <h2 class="section-title">数据分析</h2>
        <p class="muted">把不同单位的指标拆到左右坐标轴显示，温湿度不再被 CO₂ 数值压扁。</p>
      </div>
      <el-select v-model="greenhouseId" placeholder="选择大棚" style="width: 260px" @change="loadAnalytics">
        <el-option v-for="item in greenhouses" :key="item.id" :label="item.name" :value="item.id" />
      </el-select>
    </section>

    <div class="metric-strip">
      <article>
        <span>当前温度</span>
        <strong>{{ latest.temperature ?? '-' }} ℃</strong>
      </article>
      <article>
        <span>当前湿度</span>
        <strong>{{ latest.humidity ?? '-' }} %</strong>
      </article>
      <article>
        <span>CO<sub>2</sub> 浓度</span>
        <strong>{{ latest.co2Ppm ?? '-' }} ppm</strong>
      </article>
      <article>
        <span>土壤湿度</span>
        <strong>{{ latest.soilMoisture ?? '-' }} %</strong>
      </article>
    </div>

    <section class="panel chart-panel chart-panel--wide">
      <div class="chart-title">
        <div>
          <h3>环境趋势</h3>
          <p class="muted">左轴显示温度、空气湿度、土壤湿度；右轴单独显示 CO₂。</p>
        </div>
        <el-segmented v-model="trendMode" :options="trendModes" @change="renderCharts" />
      </div>
      <div ref="trendRef" class="chart chart--large"></div>
    </section>

    <div class="analytics-grid">
      <section class="panel chart-panel">
        <h3>设备状态</h3>
        <div ref="deviceRef" class="chart"></div>
      </section>
      <section class="panel chart-panel">
        <h3>告警级别</h3>
        <div ref="alertRef" class="chart"></div>
      </section>
      <section class="panel chart-panel">
        <h3>大棚面积结构</h3>
        <div ref="areaRef" class="chart"></div>
      </section>
    </div>
  </div>
</template>

<script setup>
import * as echarts from 'echarts'
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import { fetchAnalytics, fetchGreenhouses } from '../services/greenhouse'

const loading = ref(false)
const greenhouses = ref([])
const greenhouseId = ref(null)
const analytics = ref(null)
const trendRef = ref(null)
const deviceRef = ref(null)
const alertRef = ref(null)
const areaRef = ref(null)
const trendMode = ref('all')
const charts = []
let resizeHandler = null

const trendModes = [
  { label: '全部指标', value: 'all' },
  { label: '只看湿度', value: 'humidity' },
  { label: '只看 CO₂', value: 'co2' }
]

const labelMap = {
  RUNNING: '运行中',
  STOPPED: '已停止',
  MAINTENANCE: '维护中',
  WARNING: '警告',
  CRITICAL: '严重',
  INFO: '提示',
  OPEN: '待处理',
  ACKNOWLEDGED: '已确认',
  RESOLVED: '已解决'
}

const latest = computed(() => {
  const rows = analytics.value?.telemetryTrend || []
  return rows[rows.length - 1] || {}
})

const normalizeSeries = rows => (rows || []).map(item => ({ name: labelMap[item.name] || item.name, value: item.value }))

const chart = el => {
  const instance = echarts.init(el)
  charts.push(instance)
  return instance
}

const unit = name => ({ 温度: '℃', 湿度: '%', 土壤湿度: '%', 'CO₂': 'ppm' }[name] || '')

const trendSeries = trend => {
  const base = [
    { name: '温度', type: 'line', smooth: true, symbolSize: 7, yAxisIndex: 0, data: trend.map(item => item.temperature), color: '#4f75d8' },
    { name: '湿度', type: 'line', smooth: true, symbolSize: 7, yAxisIndex: 0, data: trend.map(item => item.humidity), color: '#67b75b' },
    { name: '土壤湿度', type: 'line', smooth: true, symbolSize: 7, yAxisIndex: 0, data: trend.map(item => item.soilMoisture), color: '#e55b62' },
    { name: 'CO₂', type: 'line', smooth: true, symbolSize: 7, yAxisIndex: 1, data: trend.map(item => item.co2Ppm), color: '#f2a93b' }
  ]
  if (trendMode.value === 'humidity') return base.filter(item => item.name.includes('湿度'))
  if (trendMode.value === 'co2') return base.filter(item => item.name === 'CO₂')
  return base
}

const renderCharts = async () => {
  await nextTick()
  charts.splice(0).forEach(item => item.dispose())
  if (!analytics.value) return
  const trend = analytics.value.telemetryTrend || []
  chart(trendRef.value).setOption({
    color: ['#4f75d8', '#67b75b', '#e55b62', '#f2a93b'],
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(255,255,255,.96)',
      borderColor: '#d7ead5',
      textStyle: { color: '#1e3526' },
      formatter: params => {
        const title = params[0]?.axisValue || ''
        const lines = params.map(item => `${item.marker}${item.seriesName}：${item.value} ${unit(item.seriesName)}`)
        return [title, ...lines].join('<br/>')
      }
    },
    legend: { top: 8, data: ['温度', '湿度', '土壤湿度', 'CO₂'] },
    grid: { left: 54, right: 64, top: 62, bottom: 72 },
    dataZoom: [
      { type: 'inside', throttle: 50 },
      { type: 'slider', height: 22, bottom: 22, borderColor: '#d7ead5', fillerColor: 'rgba(91, 173, 92, .18)' }
    ],
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: trend.map(item => new Date(item.collectedAt).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }))
    },
    yAxis: [
      {
        type: 'value',
        name: '℃ / %',
        min: 0,
        max: 100,
        splitLine: { lineStyle: { color: '#dfebdd' } }
      },
      {
        type: 'value',
        name: 'CO₂ ppm',
        min: value => Math.max(0, Math.floor(value.min / 100) * 100 - 100),
        max: value => Math.ceil(value.max / 100) * 100 + 100,
        splitLine: { show: false }
      }
    ],
    series: trendSeries(trend)
  })

  chart(deviceRef.value).setOption({
    tooltip: {},
    grid: { left: 42, right: 16, top: 28, bottom: 34 },
    xAxis: { type: 'category', data: normalizeSeries(analytics.value.deviceStatus).map(item => item.name) },
    yAxis: { type: 'value', minInterval: 1 },
    series: [{ type: 'bar', data: normalizeSeries(analytics.value.deviceStatus).map(item => item.value), itemStyle: { color: '#49a35a', borderRadius: [6, 6, 0, 0] } }]
  })
  chart(alertRef.value).setOption({
    tooltip: { trigger: 'item' },
    series: [{ type: 'pie', radius: ['42%', '70%'], data: normalizeSeries(analytics.value.alertLevel) }]
  })
  chart(areaRef.value).setOption({
    tooltip: { trigger: 'item' },
    series: [{ type: 'pie', roseType: 'area', radius: [20, 100], data: normalizeSeries(analytics.value.greenhouseAreas) }]
  })
}

const loadAnalytics = async () => {
  if (!greenhouseId.value) return
  loading.value = true
  try {
    analytics.value = await fetchAnalytics(greenhouseId.value)
    await renderCharts()
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  greenhouses.value = await fetchGreenhouses()
  greenhouseId.value = greenhouses.value[0]?.id || null
  await loadAnalytics()
  resizeHandler = () => charts.forEach(item => item.resize())
  window.addEventListener('resize', resizeHandler)
})

onBeforeUnmount(() => {
  charts.splice(0).forEach(item => item.dispose())
  if (resizeHandler) window.removeEventListener('resize', resizeHandler)
})
</script>

<style scoped>
.analytics-head, .chart-title {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}
.metric-strip {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
}
.metric-strip article {
  min-height: 92px;
  padding: 16px;
  border: 1px solid var(--line);
  border-radius: var(--radius);
  background: rgba(255, 255, 255, .82);
}
.metric-strip span {
  color: var(--muted);
  font-weight: 800;
}
.metric-strip strong {
  display: block;
  margin-top: 10px;
  color: var(--ink);
  font-size: 26px;
}
.analytics-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}
.chart-panel h3 {
  margin: 0 0 12px;
  color: var(--ink);
}
.chart-title h3,
.chart-title p {
  margin: 0;
}
.chart-title p {
  margin-top: 6px;
}
.chart {
  width: 100%;
  height: 330px;
}
.chart--large {
  height: 470px;
}
@media (max-width: 1100px) {
  .metric-strip,
  .analytics-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
@media (max-width: 760px) {
  .analytics-head,
  .chart-title {
    align-items: stretch;
    flex-direction: column;
  }
  .metric-strip,
  .analytics-grid {
    grid-template-columns: 1fr;
  }
}
</style>
