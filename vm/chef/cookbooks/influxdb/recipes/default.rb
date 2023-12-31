# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'c2d-config::create-self-signed-certificate'

apt_repository 'influxdb' do
  uri node['influxdb']['repo']['uri']
  components node['influxdb']['repo']['components']
  key node['influxdb']['repo']['key']
end

package 'influxdb2'

cookbook_file '/opt/c2d/influxdb-utils' do
  source 'influxdb-utils'
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

c2d_startup_script 'influxdb'
