deploy_backend_app:
	kubectl apply -f "kubernetes-manifests/mysql/*.yaml"
	kubectl exec -i `kubectl get pod | grep mysql | awk '{print $1}'` -- mysql -h localhost -u root \
	--password=`kubectl get secret mysql-root-password -o jsonpath='{.data.secretKey}' | base64 -d` < init.sql
	kubectl apply -f "kubernetes-manifests/backend/*.yaml"

deploy_frontend_app:
	kubectl apply -f "kubernetes-manifests/frontend/*.yaml"

delete_backend_app:
	kubectl delete -f "kubernetes-manifests/mysql/*.yaml"
	kubectl delete -f "kubernetes-manifests/backend/*.yaml"

delete_frontend_app:
	kubectl delete -f "kubernetes-manifests/frontend/*.yaml"

enable_monitoring:
	kubectl apply -f "kubernetes-manifests/prometheus/*.yaml"
	kubectl apply -f "kubernetes-manifests/prometheus/kube-state-metrics/*.yaml"
	kubectl apply -f "kubernetes-manifests/grafana/*.yaml"

disable_monitoring:
	kubectl delete -f "kubernetes-manifests/prometheus/*.yaml"
	kubectl delete -f "kubernetes-manifests/prometheus/kube-state-metrics/*.yaml"
	kubectl delete -f "kubernetes-manifests/grafana/*.yaml"

deploy_complete_stack_local:
	deploy_backend_app
	deploy_frontend_app
	enable_monitoring

delete_complete_stack_local:
	delete_backend_app
	delete_frontend_app
	disable_monitoring